// LMTD2010 main file, 25/11/2010
//done // todo -- add a system to play automatic improv recordings in installation mode
//done // todo -- cut the main LMTD theme from performance mode.... better to play this over skype or be in installation mode.
// todo -- add something to pretend to change coherence density movement in installation mode (i.e., when there's no midi input.).
// todo -- in installation mode, should choose a random scene depth each time. random from 0-4
// todo -- forward the arduino messages
// 28/08/2014 - Updated to eight channel version for Listening Space.

// boot server.
Server.default = s = Server.local;
s.quit;
o = Server.local.options;
o.numOutputBusChannels = 8;
o.memSize = 65536*2;
o.maxNodes = 4096*2;
//TempoClock.default
// GUI.cocoa;

s.waitForBoot({(
// Load data
~mainPath = thisProcess.nowExecutingPath.dirname ++ "/";
~audioPath = ~mainPath ++ "audio/";
//
// Audio Output Config Listening Space Mode
~mainOutput = 0;
~mainChannels = 4; // quad at each 2d plane.
~voxOutput = 4; // addresses lower speakers
~backgroundOutput = 0; // addresses upper speakers

// Normal Stereo Mode
// ~voxOutput = 0;
// ~backgroundOutput = 0;
// ~mainOutput = 0;
// ~mainChannels = 2;

// Installation mode - Plays lots more sounds behind each scene to make up for lack of live performers.
//~installationMode = false;
~installationMode = true;
~sectionChangeScheduling = false;

// Other Performances Vars
~buzzingMotors = false;
~arduinoSounds = false;

// -- Master Audio Level Definitions (set low for the Listening Space)
~masterLevelHigh = 0.4; //1.0
~masterLevelLow = 0.1;
~masterLevelMedium = 0.2; //0.85
~masterLevelVeryLow = 0.03;
// -- Initial Depth and Section definitions
~masterDepth = 0;
~sectionDepth = [0,0,0,0,0,0,0,0,0,0];
~currentSection = 9;
//

//	Load Synthdefs
thisProcess.interpreter.executeFile(~mainPath ++ "lmtdSynthDefs.scd");
// Load Sounds
thisProcess.interpreter.executeFile(~mainPath ++ "loadSounds.scd");
//
// Control Bus and variable definitions
//
~masterLevelBus = Bus.control;
~masterLevelBus.set(0.5);
~masterLevelVar = 1;
//
~masterCoherence = Bus.control;
~masterCoherence.set(0.3);
~masterCoherenceVar = 0.3;

~masterDensity = Bus.control;
~masterDensity.set(0.4);
~masterDensityVar = 0.4;

~masterMovement = Bus.control;
~masterMovement.set(0.5);
~masterMovementVar = 0.5;

// Global variables for PBinds
// Patterns for the pBinds.
~dur1 = Pseq([1,1,2], inf);
~dur2 = Pseq([0.75,0.75,1.5],inf);
~dur3 = Prand([0.6,0.35,0.7,0.35,0.225,0.125],inf);
~dur4 = Prand([0.5,0.25,0.5,0.25,0.125,0.125],inf);

~rateLow = Prand([0.5,0.5,0.5,0.25,0.25,0.125,0.125],inf);
~rateMid = Prand([0.5,1,1.5],inf);

~starts = Prand([0,0.1,0.2,0.3,0.4,0.5,0.6,0.55,0.45,0.35,0.23,0.13,0.06],inf);

~starts2 = Prand([0,0.1,0.2,0.3,0.4,0.5,0.6,0.65,0.7,0.75,0.8,0.85,0,9,0.53,0.67,0.73,0.82,0.11,0.03,0.55,0.45,0.35,0.23,0.13,0.06],inf);

~rel = Prand([0.5,0.6,0.7,0.75,0.77,0.8,0.85,0.9,0.93,0.95,1],inf);
~amp = Prand([0.3,0.4,0.45,0.5,0.55,0.6,0.63,0.65],inf);
~pans = Prand([-1,-0.8,-0.6,-0.4,-0.2,0,0.2,0.4,0.6,0.8,1],inf);

~rVibLp = Prand(~vibesLp,inf);
~rGloLp = Prand(~glockLp,inf);
~rMarLp = Prand(~marLp,inf);
~rField = Pxrand(~fieldRecordings,inf);
~rMarImprov = Pxrand(~marimbaImprovBufs,inf);
~rVibeImprov = Pxrand(~vibraphoneImprovBufs,inf);
// Finished loading data
);

( // Load Control Functions.
//	Stop sounds function
~stopSounds = {
	("LMTD	Stopping Sounds...").postln;
	// First make sure everything is off
	~vibesSynth.set(\gate,0);

	~cyberConcRoutine.stop;
	~cyberConcSynth.set(\gate,0);

	~bioExpSynth1.set(\on,0);
	~bioExpSynth2.set(\on,0);
	~bioExpSynth1.free;
	~bioExpSynth2.free;

	~bioClimaxSynth.set(\gate,0);

	~bioConcSynth1.set(\gate,0);
	~bioConcSynth2.set(\gate,0);

	~transExpSynth1.set(\on,0);
	~transExpSynth2.set(\on,0);
	~transExpSynth1.free;
	~transExpSynth2.free;

	~transConcSynth.set(\gate,0);

	~initVoxSynth.set(\gate,0);

	~stopFields.value();
	~marImp1.stop;
	~marImp2.stop;
	~vibLoop.stop;
	~marLoop.stop;
	~gloLoop.stop;

	~buzzingMotors = false;
	~arduinoSounds = false;
};

// start sounds function.
~startSounds = {
	~masterDepth = 0;
	~sectionDepth = [0,0,0,0,0,0,0,0,0,0];
	~currentSection = -1;
	("LMTD	Starting Sounds...").postln;

	// Pbinds for Field recordings.
	~fields1= Pbindef(\fields1, \instrument, \bindEnv, \bufnum, ~rField, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5* ~rel, \dur, 20 * ~dur4, \amp, 0.4 * ~masterLevelBus.asMap, \bufrate, 1, \pan,~pans, \out, ~backgroundOutput);
	~fields2= Pbindef(\fields2, \instrument, \bindEnv, \bufnum, ~rField, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5*  ~rel, \dur, 20 * ~dur3, \amp, 0.4 * ~masterLevelBus.asMap, \bufrate, 1, \pan,~pans, \out, ~backgroundOutput);
	// Auto improvise pBinds
	~marImp1= Pbindef(\marimbaImprov1, \instrument, \bindEnv, \bufnum, ~rMarImprov, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5* ~rel, \dur, 20 * ~dur4, \amp, ~masterLevelLow, \bufrate, 1, \pan,~pans, \out, ~backgroundOutput);
	~marImp2= Pbindef(\marimbaImprov2, \instrument, \bindEnv, \bufnum, ~rMarImprov, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5*  ~rel, \dur, 20 * ~dur3, \amp, ~masterLevelLow, \bufrate, 1, \pan,~pans, \out, ~backgroundOutput);

	// Adjust field recording parameters
	~fieldParams = {
		arg coherence, density, movement, level;
		var amp = 0.2 + (level * 0.5);
		var rel = (5 * coherence) + 0.5;
		var sus = (30 * coherence * density) + 0.5;
		var dur = (20 * coherence * density) + 1;
		var rate = if (coherence > 0.5, {1},{~rateMid});

		Pbindef(\fields1, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur4, \amp, 0.3 * ~masterLevelBus.asMap, \bufrate, rate, \out, ~backgroundOutput);
		Pbindef(\fields2, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur3, \amp, 0.3 * ~masterLevelBus.asMap, \bufrate, rate, \out, ~backgroundOutput);

		Pbindef(\marimbaImprov1, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur4, \out, ~backgroundOutput);
		Pbindef(\marimbaImprov2, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur3, \out, ~backgroundOutput);
	};

	// Start the field recordings
	~startFields = {
		~fields1.play;
		~fields2.play;
	};

	// Stop the field recordings
	~stopFields = {
		~fields1.stop;
		~fields2.stop;
	};

	~setImprovVibes = {
		Pbindef(\marimbaImprov1,\bufnum,~rVibeImprov);
		Pbindef(\marimbaImprov2,\bufnum,~rVibeImprov);
	};

	~setImprovMarimba = {
		Pbindef(\marimbaImprov1,\bufnum,~rMarImprov);
		Pbindef(\marimbaImprov2,\bufnum,~rMarImprov);
	};

	// Start the marimba improvisor
	~startOneImprov = {
		~marImp1.play;
	};

	~startTwoImprov = {
		~marImp1.play;
		~marImp2.play;
	};

	// Stop the marimba improvisor
	~stopImprov = {
		~marImp1.stop;
		~marImp2.stop;
	};


	// Pbinds for percussion ambient
	// Initial setup for the pBinds
	~loop1= Pbindef(\loop1, \instrument, \bindEnv, \bufnum, ~vibesLp[0], \startpos, ~starts, \sus, 0.5*~starts, \release, 3*~rel, \dur, 5*~dur4, \amp, 0.2, \bufrate, ~rateLow, \pan,~pans, \out, ~backgroundOutput);
	~loop2= Pbindef(\loop2, \instrument, \bindEnv, \bufnum, ~vibesLp[0], \startpos, ~starts, \sus, 0.5*~starts, \release, 3*~rel, \dur, 5*~dur3, \amp, 0.2, \bufrate, ~rateMid, \pan,~pans, \out, ~backgroundOutput);
	~loop3= Pbindef(\loop3, \instrument, \bindEnv, \bufnum, ~marLp[0], \startpos,~starts,\sus, 0.5 * ~starts,\release,3*~rel, \dur, 5*~dur1, \amp, 0.2, \bufrate, ~rateMid,\pan, ~pans, \out, ~backgroundOutput);
	~loop4= Pbindef(\loop4, \instrument, \bindEnv, \bufnum, ~marLp[0], \startpos,~starts,\sus, 0.5 * ~starts,\release,3*~rel, \dur, 5*~dur2, \amp, 0.2, \bufrate, ~rateLow,\pan, ~pans, \out, ~backgroundOutput);
	~loop5= Pbindef(\loop5, \instrument, \bindEnv, \bufnum, ~glockLp[0], \startpos,~starts,\sus, 0.5 * ~starts,\release,3*~rel, \dur, 5*~dur4, \amp, 0.2, \bufrate, ~rateMid, \pan, ~pans, \out, ~backgroundOutput);
	~loop6= Pbindef(\loop6, \instrument, \bindEnv, \bufnum, ~glockLp[0], \startpos,~starts,\sus, 0.5 * ~starts,\release,3*~rel, \dur, 5*~dur3, \amp, 0.2, \bufrate, ~rateLow, \pan, ~pans, \out, ~backgroundOutput);

	// Loop Layers
	~vibLoop = Ppar([~loop1, ~loop2]).play;
	~marLoop = Ppar([~loop3, ~loop4]).play;
	~gloLoop = Ppar([~loop5, ~loop6]).play;
	~vibLoop.stop;
	~marLoop.stop;
	~gloLoop.stop;
	//

	~loopChord1 = {
		Pbindef(\loop1, \instrument, \bindEnv,\bufnum, ~vibesLp[0]);
		Pbindef(\loop2, \instrument, \bindEnv,\bufnum, ~vibesLp[0]);
		Pbindef(\loop3, \instrument, \bindEnv,\bufnum, ~marLp[0]);
		Pbindef(\loop4, \instrument, \bindEnv,\bufnum, ~marLp[0]);
		Pbindef(\loop5, \instrument, \bindEnv, \bufnum, ~glockLp[0]);
		Pbindef(\loop6, \instrument, \bindEnv,\bufnum, ~glockLp[0]);
	};

	~loopChord2 = {
		Pbindef(\loop1, \instrument, \bindEnv,\bufnum, ~vibesLp[1]);
		Pbindef(\loop2, \instrument, \bindEnv,\bufnum, ~vibesLp[1]);
		Pbindef(\loop3, \instrument, \bindEnv,\bufnum, ~marLp[1]);
		Pbindef(\loop4, \instrument, \bindEnv,\bufnum, ~marLp[1]);
		Pbindef(\loop5, \instrument, \bindEnv,\bufnum, ~glockLp[1]);
		Pbindef(\loop6, \instrument, \bindEnv,\bufnum, ~glockLp[1]);
	};

	~loopChord3 = {
		Pbindef(\loop1, \instrument, \bindEnv,\bufnum, ~vibesLp[2]);
		Pbindef(\loop2, \instrument, \bindEnv,\bufnum, ~vibesLp[2]);
		Pbindef(\loop3, \instrument, \bindEnv,\bufnum, ~marLp[2]);
		Pbindef(\loop4, \instrument, \bindEnv,\bufnum, ~marLp[2]);
		Pbindef(\loop5, \instrument, \bindEnv,\bufnum, ~glockLp[2]);
		Pbindef(\loop6, \instrument, \bindEnv,\bufnum, ~glockLp[2]);
	};

	~loopCrazy = {
		Pbindef(\loop1, \instrument, \bindPerc, \bufnum, ~rVibLp);
		Pbindef(\loop2, \instrument, \bindPerc, \bufnum, ~rVibLp);
		Pbindef(\loop3, \instrument, \bindPerc, \bufnum, ~rMarLp);
		Pbindef(\loop4, \instrument, \bindPerc, \bufnum, ~rMarLp);
		Pbindef(\loop5, \instrument, \bindPerc, \bufnum, ~rGloLp);
		Pbindef(\loop6, \instrument, \bindPerc, \bufnum, ~rGloLp);
	};

	~loopExtraCrazy = {
		arg coh = 0.2;
		Pbindef(\loop1, \instrument, \lmtdVocalPlayer, \bufnum, ~rVibLp, \coherence, coh);
		Pbindef(\loop2, \instrument, \lmtdVocalPlayer, \bufnum, ~rVibLp, \coherence, coh);
		Pbindef(\loop3, \instrument, \lmtdVocalPlayer, \bufnum, ~rMarLp, \coherence, coh);
		Pbindef(\loop4, \instrument, \lmtdVocalPlayer, \bufnum, ~rMarLp, \coherence, coh);
		Pbindef(\loop5, \instrument, \lmtdVocalPlayer, \bufnum, ~rGloLp, \coherence, coh);
		Pbindef(\loop6, \instrument, \lmtdVocalPlayer, \bufnum, ~rGloLp, \coherence, coh);
	};

	~loopParams = {arg coherence = 0.8, density = 0.9, movement = 0.6, level = 0.2;
		var amp = 0.1; // master level balance for the loops
		var dur = (25 + (movement * -24));
		var att = (0.2 + 2 * density) * (1 -  (0.5 * movement));
		var sus = (0.1 + 3 * density) * (1 - movement);
		var rel = (0.3 + 3 * density) * (1 -  (0.5 * movement));
		var layerScale = (1 - 0.6 * (movement * density));
		Pbindef(\loop1,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur4, \amp, layerScale * amp * ~masterLevelBus.asMap);
		Pbindef(\loop2,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur3, \amp, layerScale * amp * ~masterLevelBus.asMap);
		Pbindef(\loop3,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur1, \amp, layerScale * amp * ~masterLevelBus.asMap);
		Pbindef(\loop4,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur2, \amp, layerScale * amp * ~masterLevelBus.asMap);
		Pbindef(\loop5,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur4, \amp, layerScale * amp * ~masterLevelBus.asMap);
		Pbindef(\loop6,\startpos,~starts,\sus, sus*~starts,\attack,att,\release,rel,
				\dur, dur*~dur3, \amp, layerScale * amp * ~masterLevelBus.asMap);

		if (coherence < 0.2, {
			Pbindef(\loop1, \instrument, \lmtdVocalPlayer, \coherence, coherence);
			Pbindef(\loop2, \instrument, \lmtdVocalPlayer, \coherence, coherence);
			Pbindef(\loop3, \instrument, \lmtdVocalPlayer, \coherence, coherence);
			Pbindef(\loop4, \instrument, \lmtdVocalPlayer, \coherence, coherence);
			Pbindef(\loop5, \instrument, \lmtdVocalPlayer, \coherence, coherence);
			Pbindef(\loop6, \instrument, \lmtdVocalPlayer, \coherence, coherence);
		}, {
			Pbindef(\loop1, \instrument, \bindEnv);
			Pbindef(\loop2, \instrument, \bindEnv);
			Pbindef(\loop3, \instrument, \bindEnv);
			Pbindef(\loop4, \instrument, \bindEnv);
			Pbindef(\loop5, \instrument, \bindEnv);
			Pbindef(\loop6, \instrument, \bindEnv);
		});
		//("LOOP PARAMETERS: Att" + att + "Sus" + sus + "Rel" + rel + "Dur" + dur).postln;
		//("LOOP PARAMETERS: LayerScale" + layerScale).postln;
	};

	//	Load the Script (Performance Structure) Functions.
	thisProcess.interpreter.executeFile(~mainPath ++ "lmtdScript.scd");
};


// OSC Responders
~startResponders = {
	("LMTD	Starting Responders...").postln;
	//Responders
	///////////////////	///////////////////	///////////////////
	// Relevant Addresses;
	// Address of Benjamin Laptop.
		~benjaminAddress = NetAddr.new("192.168.1.255", 57120);
	// Address of Arduino
		~arduinoAddress = NetAddr.new("192.168.1.255", 10000);
	// Broadcast Address
		NetAddr.broadcastFlag = true;
		~broadcastAddress = NetAddr.new("192.168.1.255", 57120);
	// MacMini
		~macmini = NetAddr.new("192.168.1.254", 57120);
	// Local
		~localAddress = NetAddr.new("127.0.0.1",57120);
	// Local processing
		~localProcessing = NetAddr.new("127.0.0.1",3000);
		//~localProcessing = NetAddr.new("192.168.1.255", 57120);

	//
	// Auto Density and Movement synths (for CCAS show and installation, December 2010)
	//
	~densitySynth.free;
	~movementSynth.free;
	~densitySynth = Synth(\slowSinRandomiser,
		[\bus,~masterDensity,\time, 0.01],addAction: \addToHead);
	~movementSynth = Synth(\slowNoiseRandomiser,
		[\bus,~masterMovement,\time, 0.6],addAction: \addToHead);

	~autoCohDenMovRoutine.stop;
	~autoCohDenMovRoutine = Routine {
		loop {
			//"Processing values:".postln;
			~masterMovement.get({arg value;
				//("Master Movement:" + value).postln;
				~broadcastAddress.sendMsg("/movement", 1, value);
				});
			~masterDensity.get({arg value;
				//("Master Density:" + value).postln;
				~broadcastAddress.sendMsg("/density", 1, value);
				});

			//~processMidiSilence.value();
			0.05.yield;
		}
	}.play;

	//
	// Section Responder.
	//
	~lastscene = 4;
	~scenetime = TempoClock.default.beats;
	~sectionResponder.remove;
	~sectionResponder = OSCresponderNode(nil, '/section', {|t, r, msg|
		var newSection = msg[1], announcementlength;
		~localProcessing.sendMsg('/section',msg[1]);

		if (newSection == ~lastscene, {  }, {
			~lastscene = newSection;
		("SECTION RESPONDER:	New section will be:" + newSection).postln;
		//~masterDepth = ~masterDepth + 1;
		"Choosing random depth... : ".post;
		~masterDepth = 10.rand.postln;

		~scriptFunctions[(2 * ~currentSection) + 1].value; // run the old section's end script
		Routine {
			// Section chime
			{
				var note1 = midicps((2 * newSection) + 60);
				var note2 = midicps((2 * newSection) + 65);
				var sound = SinOsc.ar([note1,note2,note2,note1], 0,
					EnvGen.ar(Env.perc(1, 0.05, ~masterLevelLow, 4),1, doneAction: 2));
				Out.ar(~voxOutput, sound);
			}.play;

			if (~sectionVox[newSection].notNil, {
				// Play the section announcement
				~voxSectionPlay = Synth(\bufferPlayer,
					[\bufnum, ~sectionVox[newSection],
					 \loop, 0, \gate,1,\amp,~masterLevelMedium,\out,~voxOutput]);
				// Wait for the length of the announcement
				(0.7 * (~sectionVox[newSection].numFrames / ~sectionVox[newSection].sampleRate)).wait;
			});

			// NOW change to the new section:
			("SECTION RESPONDER:		Activating Section" + newSection).postln;
			// Increment Section Depth Counter
			~sectionDepth[newSection] = ~sectionDepth[newSection] + 1;
			// installation mode!!!
			if (~installationMode, {
				"Choosing random section depth... (installation mode): ".post;
				~sectionDepth[newSection] = 5.rand.postln;
			});
			~scriptFunctions[(2 * newSection)].value; // run the new section's start script.
			~currentSection = newSection;	// update vars
			~updateGuiSection.value(); // update GUI
		}.play;

		});
	}).add;

	//Section End Responder
	~sectionEndResponder.remove;
	~sectionEndResponder = OSCresponderNode(nil, '/sectionend', {|t, r, msg|
		var section = ~currentSection;
		("SECTION:	Ending Section:" + ~masterDepth).postln;
		~sectionEndActions[~masterDepth].value;

		// End section chime:
		{
			var note1 = midicps((2 * section) + 60);
			var note2 = midicps((2 * section) + 65);
			var sound = SinOsc.ar([note1,note2,note2,note1], 0,
				EnvGen.ar(Env.perc(0.2, 0.5, ~masterLevelLow, -4),1, doneAction: 2));
			Out.ar(~voxOutput, sound);
		}.play;
	}).add;

	~randomSectionResponder.remove;
	~randomSectionResponder = OSCresponderNode(nil, '/sectionrand', {|t, r, msg|
		("START RANDOM SECTION").postln;
		~localAddress.sendMsg("/section",9.rand);
	}).add;

	//	Update Sounds Responder
	~updateSoundsResponder.remove;
	~updateSoundsResponder = OSCresponderNode(nil, '/updatesounds', {|t,r,msg|
		var coh = if (msg[1].isPositive, msg[1], ~masterCoherenceVar);
		var den = if (msg[2].isPositive, msg[2], ~masterDensityVar);
		var mov = if (msg[3].isPositive, msg[3], ~masterMovementVar);
		var lev = if (msg[4].isPositive, msg[4], ~masterLevelVar);

		//("UPDATE SOUNDS OSC: " + msg).postln;
		~loopParams.value(coh,den,mov,lev);	// Update loops
		~fieldParams.value(coh,den,mov,lev);	// Update fields
		~masterCoherence.set(coh);
		~masterDensity.set(den);
		~masterMovement.set(mov);

		~masterLevelBus.set(lev);

		/*if (abs(lev - ~masterLevelVar) > 0.1,
			{
				~masterLevelBus.get({arg value; Synth(\fade,[\bus,~masterLevelBus,\start,value,
					\end,lev,\time,2],addAction: \addToHead);}); // fade master level to new lev.
			},{
				~masterLevelBus.set(lev);
			});
			*/
		//if (msg[4].notNil, {
		//	~masterLevelBus.get({arg value; Synth(\fade,[\bus,~masterLevelBus,\start,value,
		//		\end,lev,\time,2],addAction: \addToHead);}); // fade master level to new lev.
		//});
		~masterCoherenceVar = coh;
		~masterDensityVar = den;
		~masterMovementVar = mov;
		~masterLevelVar = lev;
		~updateGuiCohDenMovLev.value();	// Update GUI with new values:
	}).add;

		~sendUpdatesResponder.remove;
	~sendUpdatesResponder = OSCresponderNode(nil, '/sendupdates', {|t,r,msg|
		var coh = if (msg[1].isPositive, msg[1], ~masterCoherenceVar);
		var den = if (msg[2].isPositive, msg[2], ~masterDensityVar);
		var mov = if (msg[3].isPositive, msg[3], ~masterMovementVar);
		var lev = if (msg[4].isPositive, msg[4], ~masterLevelVar);

		//("UPDATE SOUNDS OSC: " + msg).postln;
		~broadcastAddress.sendMsg("/coherence",1,coh);
		~broadcastAddress.sendMsg("/density",1,den);
		~broadcastAddress.sendMsg("/movement",1,mov);
	}).add;


	// QR Code Messages
	~qrCodeResponder.remove;
	~qrCodeResponder = OSCresponderNode(nil, '/qrcode', {|t, r, msg|
		var newSection = msg[1];
		("QRCODE:		QrCode:" + newSection).postln;
	}).add;

	// Arduino Responder.
	(
	~arduinoResponder.remove;
	~lastAccel = 0;
	~lastSoundTime = TempoClock.default.beats;
	~arduinoResponder = OSCresponderNode(nil, '/ardnunchuck', {|t, r, msg|
		var newAccel = msg[4];
		var delta = (newAccel - ~lastAccel);
		~lastAccel = newAccel;
		if (~arduinoSounds, {
			// normal is 50
			// trying 60, 1 10 2010
			if (delta > 60 && (TempoClock.default.beats > (~lastSoundTime + 1)), {
				 				// SENSITIVITY.
				 ~lastSoundTime = TempoClock.default.beats;
				("	ARDUINO High Accleration Change:" + delta + "Time:" + ~lastSoundTime).postln;
				// Arduino motion chime sound.
				{
					var sound = SinOsc.ar([midicps((2 * 5.rand) + 60),midicps((2 * 5.rand) + 65)], 0,
									    EnvGen.ar(Env.perc(((1 + 2.rand) / 10), 0.05, ((1 + 2.rand) / 15), 4),1,
									    doneAction: 2));
					Out.ar(~voxOutput,sound)
				}.play;
			});
			// maybe delta > 50 and then delta > 80
		});
	}).add;
	);

	// Arduino pulse responder.
	// sends ard pulses from other clients to port 3000 on the local machine.
	(
	~ardPulseResponder.remove;
	~ardPulseResponder = OSCresponderNode(nil,'/ardpulse', {|t,r,msg|
		~localProcessing.sendMsg('/ardpulse',msg[1]);
	}).add;
	);

	// Ben Smear Parameter
	~smearResponder.remove;
	~smearResponder = OSCresponderNode(nil, '/ben/smear', {|t, r, msg|
		if (((msg[1] <= 1) && (msg[1] >= 0)), ~localAddress.sendMsg("/coherence",msg[1]));
		//("bensmear ").postln;
	}).add;

	~coherenceResponder.remove;
	~coherenceResponder = OSCresponderNode(nil, '/coherence', {|t, r, msg|
		//~localAddress.sendMsg("/updatesounds", msg[2], -1, -1, -1);
		switch (msg[1],
			0, {~localAddress.sendMsg("/updatesounds", msg[2], -1, -1, -1);
				//msg.postln;
				}, //Ben
			1, {
				//~localAddress.sendMsg("/updatesounds", msg[2], -1, -1, -1);
				}, //Charles
			2, {} //Hanna
			);
		//~masterCoherence.set(msg[1]);
		//("External OSC		Set Coherence =" + msg[2]).postln;
	}).add;

	~densityResponder.remove;
	~densityResponder = OSCresponderNode(nil, '/density', {|t, r, msg|
		//~localAddress.sendMsg("/updatesounds", -1, msg[2], -1, -1);
		//~masterDensity.set(msg[1]);
		switch (msg[1],
			0, {~localAddress.sendMsg("/updatesounds", -1, msg[2], -1, -1);
				}, //Ben
			1, {
				//~localAddress.sendMsg("/updatesounds", -1, msg[2], -1, -1);
				}, //Charles
			2, {} //Hanna
			);
		//("External OSC		Set Density =" + msg[2]).postln;
	}).add;

	~hMovement = 0;
	~bMovement = 0;

	~movementResponder.remove;
	~movementResponder = OSCresponderNode(nil, '/movement', {|t, r, msg|
		//~localAddress.sendMsg("/updatesounds", -1, -1, msg[2], -1);
		switch (msg[1],
			0, {~	bMovement = msg[2];
				~localAddress.sendMsg("/updatesounds", -1, -1, max(~hMovement,~bMovement), -1);
				//~localAddress.sendMsg("/updatesounds", -1, -1, ~bMovement, -1);
				//msg[2].postln;
				}, //Ben
			1, {}, //Charles
			2, {
				//~hMovement = msg[2];
				//~localAddress.sendMsg("/updatesounds", -1, -1, max(~hMovement,~bMovement), -1);
				} //Hanna
			);
		//("External OSC		Set Movement =" + msg[2]).postln;
	}).add;

	~levelResponder.remove;
	~levelResponder = OSCresponderNode(nil, '/level', {|t, r, msg|
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, msg[1]);
		//("External OSC		Set Level =" + msg[1]).postln;
	}).add;

	//	Load MIDI.
	thisProcess.interpreter.executeFile(~mainPath ++ "midiStrikeCounter.scd");
	thisProcess.interpreter.executeFile(~mainPath ++ "midiVelocityCounter.scd");
	thisProcess.interpreter.executeFile(~mainPath ++ "lmtdMIDI.scd");
};

);

//	Load GUI.
thisProcess.interpreter.executeFile(~mainPath ++ "lmtdGUI.scd");


// Section Change Scheduling
	~sectionChangeScheduling = true;

	~scheduleNextSectionChange = {
		if (~sectionChangeScheduling,{
			("Changing Section Chane from Section!").postln;
			~localAddress.sendMsg("/section",9.rand);
		},{});
		("Scheduling next section change...").postln;
		SystemClock.sched(200, {
			~scheduleNextSectionChange.value();
		});
	};

	if (~sectionChangeScheduling,{~scheduleNextSectionChange.value()},{});

});
