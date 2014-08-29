//
//	The Last Man to Die	-	2010
//
//	SynthDefs
//
//
//
("LMTD2010	-	Loading SynthDefs").postln;
//

// Remember to initialise
// ~voxOutput
// ~backgroundOutput
// ~mainOutput
// and ~mainChannels = (2 or 4 channels?)
/*~voxOutput = 0;
~backgroundOutput = 0;
~mainOutput = 0;
~mainChannels = 2;*/



//
// Play a buffer simply.    ??????? UNUSED!
//
SynthDef(\playBuf,{
	|pan=0, bufnum=0, loop=0, out=0, amp=0.5, sus=114, attack=0.5, release=4.5, startpos=0, rate=1|
	var env, signal, bFormat;
	env = EnvGen.kr(Env.linen(attack, sus, release, 1, curve:4),doneAction:2);
	signal = PlayBuf.ar(2, bufnum,  BufRateScale.kr(bufnum)*rate, startPos: startpos, loop:loop, doneAction:2) * env;

	bFormat = BiPanB2.ar(signal[0], signal[1], pan, amp);
	Out.ar(~mainChannels, DecodeB2.ar(2, bFormat[0], bFormat[1], bFormat[2]));
	FreeSelfWhenDone.kr(out);
}).store;



//
//	Buffer Player for Vocals, stereo version
//
SynthDef(\bufferPlayer, {
	arg out = ~voxOutput, bufnum = 0, loop = 0, amp = 1, gate = 0, attack = 0.05, release = 0.05, rate = 1, pan = 0;
	var source, bFormat, env;
	source = PlayBuf.ar(2, bufnum, 1,1,0,loop);
	source = source * amp;
	env =  EnvGen.kr(Env.asr(attack,1,release), gate,doneAction: 2);
	source = source * env;
	bFormat = BiPanB2.ar(source[0], source[1], pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	//FreeSelfWhenDone.kr(source);
}).store;

// Buffer Player for Vocals, stereo version
SynthDef(\bufferPlayerMono, {
	arg out = ~voxOutput, bufnum = 0, loop = 0, amp = 1, gate = 0, attack = 0.05, release = 0.05, rate = 1, pan = 0;
	var source, bFormat, env;
	source = PlayBuf.ar(1, bufnum, 1,1,0,loop);
	env =  EnvGen.kr(Env.asr(attack,amp,release), gate,doneAction: 2);
	source = source * env;
	bFormat = PanB2.ar(source, pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	//FreeSelfWhenDone.kr(source);
}).store;

//
//	Buffer Player for Music Cues
//
SynthDef(\musicPlayer, {
	arg out = ~backgroundOutput, bufnum = 0, loop = 0, amp = 1, gate = 0, attack = 0.05, release = 0.05, rate = 1, pan = 0, startPos = 0;
	var source, bFormat, env;
	// convert startpos to frames from seconds;
	startPos = startPos * 44100;
	source = PlayBuf.ar(2, bufnum, 1,1,startPos,loop);
	env =  EnvGen.kr(Env.asr(attack,amp,release), gate,doneAction: 2);
	source = source * env;
	bFormat = BiPanB2.ar(source[0], source[1], pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	FreeSelfWhenDone.kr(source);
}).store;

//
// Play buffer for pBinds (music)
//
SynthDef(\bindEnv,{ |startpos=0, endpos = 1, amp=1, bufnum=0, attack=0.05, sus=1, release=0.5, loop=1, bufrate=1, out=4, pan=0|
	var env, source, rate, total, duration, start, end, bFormat;
	total = BufFrames.kr(bufnum);
	start = startpos*total;
	end = endpos*total;
	duration = abs(end - start) / 44100;
	rate = BufRateScale.kr(bufnum)*bufrate;

	source = PlayBuf.ar(1, bufnum,  rate, 1, start, loop);
	source = source *	EnvGen.kr(Env.linen(0.05, 0.98, 0.05),
							timeScale: duration,
							gate: Impulse.kr(1/duration));
	env = EnvGen.kr(Env.linen(attack, sus, release, 1, curve:2),doneAction:2);
	source = source * env;
	bFormat = PanB2.ar(source, pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	FreeSelfWhenDone.kr(source);
}).store;


//
// Play buffer for pBinds with percussive envelope
//
SynthDef(\bindPerc,{ |startpos=0, endpos = 1, amp=1, bufnum=0, attack=0.05, sus=1, release=2, loop=0, bufrate=1, out=4, pan = 0|
	var env, source, rate, total, duration, start, end, bFormat;
	total = BufFrames.kr(bufnum);
	start = startpos*total;
	rate = BufRateScale.kr(bufnum)*bufrate;

	source = PlayBuf.ar(1, bufnum,  rate, 1, start, loop);
	env = EnvGen.kr(Env.perc(attack, release, 1, 4),doneAction:2);
	//env = EnvGen.kr(Env.perc(attack, release, 1, -4),doneAction:2);
	source = source * env;
	bFormat = PanB2.ar(source, pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	FreeSelfWhenDone.kr(source);
}).store;

//
//	Vocal Cue Player
//
SynthDef(\lmtdVocalPlayer, {
	arg out = ~backgroundOutput, freq = 1, attack = 0.5, release = 0.5, amp = 1, gate = 1,
		bufnum = 0, srate = 44100, start = 0, end = 1,
		pan = 0,  masterLevel = 1, coherence = 1, density = 1,
		eventTrigger = 0, eventMagnitude = 0, on = 1;
	var source, duration, total; // Buffer Details
	var rate, rateMul, rateAdd, changeRate, changeAmount; // Rate Modification
	var probability = 0, envRate = 3; // Envelope Generation Details
	var newPan; // Panning Vars
	var bFormat, env;

	// Setup Buffer
	total = BufFrames.kr(bufnum)/44100; // Calculate the total seconds in the file
	end = end*total; start = start*total; // Change to seconds values
	duration = abs(end - start);

	// Rate modification
	rateMul = 3 * abs(1 - coherence);
	rateAdd = coherence;
	changeRate = 1;
	changeAmount = 1;
	rate = LFNoise0.kr(LFNoise0.kr(changeRate,changeAmount,2), rateMul, rateAdd);

	// Envelope generation
	probability = density * (1 - (0.3 * (abs(1 - coherence))));

	// Pan Generation
	newPan = pan + LFNoise2.kr((5 * abs(1 - coherence)) + 0.1, abs(1 - coherence), 0);

	// Sound generation
	source = BufRd.ar(1, bufnum, // Buffer 0
		LinLin.ar( // Organise looping and rate playback
			LFSaw.ar(rate/duration, 1), -1, 1, start, end)*srate
			)*EnvGen.kr(Env.linen(0.01, 0.98, 0.01), timeScale: duration,
			gate: Impulse.kr(1/duration));
	source = Pan2.ar(source,pan,masterLevel); // Panning

	// ASR envelope is controlled by LFNoise0, based on adjusted probability and density.
	// Percussion envelope is controlled by "eventTrigger" and "eventMagnitude" but ONLY
	// if "gate" is open. - i.e. only for currently active Synths
	// So, ASR is the random envelope, Perc is the controlled envelope.
	source = source * clip2( // Calculate Envelopes
		(
			EnvGen.ar(Env.asr(1,1,1),	// Envelopes
				LFNoise0.kr(envRate, add: ((2 * probability) - 1)) * on ) // Gate
			+ EnvGen.ar(Env.perc(0.1, 2, eventMagnitude, -4), (eventTrigger * on))
		), 1);

	// Sensible outer envelope and ambisonic processing
	env =  EnvGen.kr(Env.asr(attack,amp,release), gate,doneAction: 2);
	source = source * env;
	bFormat = BiPanB2.ar(source[0],source[1], pan, 1);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	//FreeSelfWhenDone.kr(source);
}).store;





//
// Grainy synth for voice overs
//
SynthDef(\LMTDGrain, {
	arg bufnum = 0, length = 1, amp = 1, out = ~backgroundOutput, gate = 1, freq = 50, durScale = 4, azimuth = 0;
	var trate, dur, rate, sound, clk, posA, posB, posX,
		panA, panB, bufLength, playRate, bFormat;
	bufLength = BufDur.kr(bufnum);
	trate = 2 + (freq) + LFNoise1.kr(0.4,freq/2,-15);
	clk = Impulse.ar(trate);
	dur = durScale / trate;
	rate = Dseq([1.44, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
	panA = WhiteNoise.kr(0.6);
	panB = WhiteNoise.kr(2);

	playRate = LFNoise1.ar(0.5,0.5,0.75);
	posA = LinLin.ar( LFSaw.ar(playRate/bufLength, 1), -1, 1, 0, 1)*bufLength;

	posX = LFNoise2.kr(1, bufLength/2, bufLength/2);
	posB = posX + TRand.kr(0, BufDur.kr(bufnum)*0.1, clk);


	sound = TGrains.ar(2, clk, bufnum, rate, posA,dur, panA, 0.5, 2);
	sound = sound + (0.5 * TGrains.ar(2, clk, bufnum, 1, posB, dur, panB, 0.5));
	sound = sound * EnvGen.ar(Env.adsr(0.01, 1, 0.8,2,1,-4),gate,doneAction:2);
	sound = Limiter.ar(sound, amp, 0.01);
	sound = FreeVerb2.ar(sound[0],sound[1],0.25,0.3,0.5,1.0);

	bFormat = BiPanB2.ar(sound[0], sound[1], MouseX.kr(-1,1), 1);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
}).store;


//
// CyberConc crackle
//
SynthDef(\shiftingCrackle, {
	arg out = ~backgroundOutput, amp = 1, gate = 0, attack = 0.05, release = 0.05, pan = 0;
	var source, bFormat, env;
	source = SinOsc.ar(BrownNoise.ar(100, 200 + LFNoise2.kr(1,50,0))) * 0.5;
	source = source + Dust.ar(500 + LFNoise2.kr(4,300,0),0.5);
	source = source * amp;
	env =  EnvGen.kr(Env.asr(attack,1,release), gate,doneAction: 2);
	source = source * env;
	bFormat = PanB2.ar(source, pan, amp);
	Out.ar(out, DecodeB2.ar(~mainChannels, bFormat[0], bFormat[1], bFormat[2]));
	//FreeSelfWhenDone.kr(source);
}).store;


//
//	Fader synth for control buses
//
SynthDef(\fade, {arg bus = 0, time = 10, start = 1, end = 0;
	Out.kr(bus, Line.kr(start,end,time,doneAction:2))
}).store;

//
// Slow changing fader for control buses.
//
SynthDef(\slowSinRandomiser, {arg bus = 0, time = 0.3, start = 1, end = 0;
	Out.kr(bus,
		//LFNoise1.kr(time,0.45,0.5)
		SinOsc.kr(time,3pi/2,0.4,0.4)
	)
}).store;

SynthDef(\slowNoiseRandomiser, {arg bus = 0, time = 0.3, start = 1, end = 0;
	Out.kr(bus,
		LFNoise2.kr(time,0.45,0.5)
		//SinOsc.kr(time,3pi/2,0.4,0.4)
	)
}).store;