//
//	These functions play sounds for each section, and stop the sounds at the end of the section
//
~scriptFunctions = [
	{ //// Section 0 ////
	  ///////////////////
	 ///////////////////
		"SECTION: Cybernetics Exposition".postln;
		//"Vibraphone Theme Playing".postln;
		//~buzzingMotors = true;
		if(~sectionDepth[0] > 0, {~buzzingMotors = true});

		if(~sectionDepth[0] == 2, {
			// play the theme tune
			//~vibesSynth = Synth(\musicPlayer, [\bufnum, ~vibesAAll,
			//	\attack, 5, \release, 15, \gate, 1]);
		});
		if(~sectionDepth[0] > 2, {
			// play the theme tune
			// Vibes melody start near marimba entry
			//~vibesSynth = Synth(\musicPlayer, [\bufnum, ~vibesAAll, \attack, 10,
			//	\release, 15, \gate, 1, \startPos, 140 + 10.rand]);
		});

		~startFields.value();
		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelLow);
	},{
		"END: Cybernetics Exposition".postln;
		~buzzingMotors = false;
		//~vibesSynth.set(\gate,0);
		~stopFields.value();
		~stopImprov.value();
	},//
	//

	{ //// Section 1 ////
		///////////////////
		///////////////////
		"SECTION: Cybernetics Climax".postln;
		~buzzingMotors = false;
		//if(~sectionDepth[1] > 0, {~buzzingMotors = true});

		if((~sectionDepth[1] > 1) && (~sectionDepth[1] <= 2), {
			//~vibesSynth = Synth(\musicPlayer, [\bufnum, ~vibesAAll,
			//	\attack, 5, \release, 15, \gate, 1]);
		});
		if(~sectionDepth[1] > 2, {
			// Vibes melody start near marimba entry
			//~vibesSynth = Synth(\musicPlayer, [\bufnum, ~vibesAAll,
			//	\attack, 10, \release, 15, \gate, 1, \startPos, 140 + 10.rand]);
		});

		~startFields.value();
		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelLow);
	},{
		"END: Cybernetics Climax".postln;
		~buzzingMotors = false;
		//~vibesSynth.set(\gate,0);
		~stopFields.value();
		~stopImprov.value();
	},//
	//

	{ //// Section 2 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Cybernetics Conclusion".postln;
		"VOX: Virus vs Human".postln;
		~arduinoSounds = false;
		~buzzingMotors = true;

		//~sectionDepth[2].postln;
		~cyberConcCoherence = 1;


		// Plays random virus/human voxes, until end of the section.
		// low coherence cuts vox short,
		// low density increases space in between each vox ** not done yet **
		~cyberVoxTime = 0.93;
		(
			~currentCyberConcVox = ~voxCyberConc[0];
			~cyberConcRoutine = Routine { arg inval;
			loop {
				//("New Cyber vox slice!").postln;
				// Play Vox quote:::
				~cyberConcSynth = Synth(\bufferPlayerMono,
					[\bufnum, ~currentCyberConcVox, \attack, 0.05,
					 \release, 0.5 , \gate, 1, \amp, ~masterLevelMedium,\pan,(rrand(-100,100)/100),\out,~voxOutput]);
			    // Warped Version::::
			    ~cyberConcSynthWarped = Synth(\lmtdVocalPlayer,
			    		[\bufnum, ~currentCyberConcVox, \pan,-0.5,
			    			\attack, 0.05, \release,0.5,
			    			\coherence, ~masterCoherence.asMap,
			    			\masterLevel, ~masterLevelMedium * (1 - ~cyberConcCoherence),
						\on, 1,\out, ~voxOutput,\pan,(rrand(-100,100)/100)]);
				// Crackling Synth::::
				~cyberConcCrackle = Synth(\shiftingCrackle,
					[\attack, 0.05, \release, 0.5 ,
					\gate, 1, \amp, ~masterLevelMedium * (1 - ~cyberConcCoherence),\pan,(rrand(-100,100)/100),\out,~backgroundOutput]);




			// time to wait before starting next synth
			//Calculate scaler... minimum is coherence, maximum is 1 -

			((0.05 + (~cyberVoxTime * ~masterCoherenceVar)) *
				(~currentCyberConcVox.numFrames / ~currentCyberConcVox.sampleRate)).yield;

			// free the old synths
			~cyberConcSynth.set(\gate,0);
			~cyberConcSynthWarped.free;
			~cyberConcCrackle.set(\gate,0);

			// choose a new vocal slice to play
			~currentCyberConcVox = ~voxCyberConc[~voxCyberConc.size.rand];
			}
			}.play;
		);

		if (~sectionDepth[2] > 2, {
			// Vibes melody start near marimba entry
			//~vibesSynth = Synth(\musicPlayer, [\bufnum, ~vibesAAll, \attack, 10,
			//	\release, 15, \gate, 1, \startPos, 140 + 10.rand]);

			~startFields.value();
		});

		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelLow);

		~cyberConcResponder.remove;
		~cyberConcResponder = OSCresponderNode(nil, '/coherence', {|t, r, msg|
			// special Coherence responder to react to benjamins values
			if (msg[1] == 0, {
				//("Setting Cyber CONC synths: " ++ msg[2]).postln;
				~cyberConcCoherence = sqrt(msg[2]); // changes length of vocal slices
				// Change the balance between normal and warped cyberConc synths

				~cyberConcSynth.set(\amp, 0.02 + (~masterLevelMedium * ~cyberConcCoherence));
				~cyberConcSynthWarped.set(\masterLevel,
					~masterLevelMedium * (1 - ~cyberConcCoherence));
				~cyberConcCrackle.set(\amp,
					~masterLevelMedium * (1 - ~cyberConcCoherence));
			});
		}).add;

		// Responder to the sectionend message so that it doesn't give the wrong message
		~cyberConcEnd.remove;
		~cyberConcEnd = OSCresponderNode(nil, '/sectionend', {|t, r, msg|
			("End of Cyber Conc" + ~masterDepth).postln;
			~cyberConcRoutine.stop;
			~cyberConcSynth.set(\gate,0);
			~cyberConcSynthWarped.set(\gate,0);
			// Last Quote play
			~cyberConcSynth = Synth(\bufferPlayerMono,[\bufnum, ~voxCyberConc[1], \attack, 0.05, \release, 0.5 ,
				\gate, 1,\amp,~masterLevelMedium,\pan,(rrand(-100,100)/100),\out,~voxOutput]);
		}).add;

	},{
		"END: Cybernetics Conclusion".postln;
		~buzzingMotors = false;

		~cyberConcResponder.remove;
		~cyberConcRoutine.stop;
		~cyberConcSynth.set(\gate,0);
		~cyberConcSynthWarped.set(\gate,0);
		~cyberConcEnd.remove;

		//~cyberConcVox1.stop;
		//~vibesSynth.set(\gate,0);
		~stopFields.value();
		~stopImprov.value();

	},//
	//
	{ //// Section 3 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Biological Exposition".postln;
		"Organisms which are Biologically Immortal...".postln;
		~arduinoSounds = true;
		~buzzingMotors = true;

		// Announce the Turritopsis Nutricula Text
		if (~sectionDepth[3] == 1, {
			~bioExpSynth1 = Synth(\bufferPlayerMono, [\bufnum, ~voxBioExp,
			\attack, 0.05, \release, 5 , \gate, 1,\loop,1,
			\amp,~masterLevelMedium,\out, ~voxOutput,\pan,(rrand(-100,100)/100)]);
		});

		// Warped version
		if(~sectionDepth[3] > 1, {
		~bioExpSynth2 =
			Synth (\lmtdVocalPlayer, [\bufnum, ~voxBioExp,\pan,(rrand(-100,100)/100),
			\coherence, ~masterCoherence.asMap, \masterLevel, ~masterLevelMedium,\amp,~masterLevelMedium,
			\on, 1,\out, ~voxOutput]);

		~bioExpSynth3 =
			Synth (\lmtdVocalPlayer, [\bufnum, ~voxBioExp, \pan,~masterCoherence.asMap,
			\coherence, ~masterCoherence.asMap, \masterLevel, ~masterLevelMedium,\amp,~masterLevelMedium,
			\on, 1,\out, ~voxOutput]);
		});


		//~localAddress.sendMsg("/updatesounds", 0.5, -1, -1, ~masterLevelLow);

		~vibLoop.play;
		//~marLoop.play;
		//~gloLoop.play;
		~loopChord1.value();
		~startFields.value();

		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		~setImprovVibes.value();
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		// Background sounds volume is "very low"
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelVeryLow);

		~bioExpEnd.remove;
		~bioExpEnd = OSCresponderNode(nil, '/sectionend', {|t, r, msg|
			("End of BioExp" + ~masterDepth).postln;
			~bioExpSynth1.set(\on,0);
			~bioExpSynth2.set(\on,0);
			~bioExpSynth3.set(\on,0);
			~bioExpSynth1.free;
			~bioExpSynth2.free;
			~bioExpSynth3.free;
		}).add;

	},{
		"END: Biological Exposition".postln;
		~buzzingMotors = false;

		~bioExpSynth1.set(\on,0);
		~bioExpSynth2.set(\on,0);
		~bioExpSynth3.set(\on,0);
		~bioExpSynth1.free;
		~bioExpSynth2.free;
		~bioExpSynth3.free;
		~bioExpEnd.remove;


		~vibLoop.stop;
		//~marLoop.stop;
		//~gloLoop.stop;
		~stopFields.value();
		~stopImprov.value();
	},//
	//

	{ //// Section 4 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Biological Climax".postln;
		"Aging Scene and Prerecorded monologue".postln;
		~buzzingMotors = false;
		~bioClimaxSynth = Synth(\bufferPlayer, [\bufnum, ~voxBioClimax, \attack, 0.05, \release, 5 , \gate, 1,
			\amp,~masterLevelMedium,\out,~voxOutput,\pan,(rrand(-100,100)/100)]);

		//~vibLoop.play;
		//~marLoop.play;
		//~gloLoop.play;
		//~loopChord2.value();
		//~startFields.value();

		//if(~sectionDepth[4] > 0, {~buzzingMotors = true});

		// no auto improv in this section

		// Background sounds volume is "very low"
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelVeryLow);
	},{
		"END: Biological Climax".postln;
		~buzzingMotors = false;
		~bioClimaxSynth.set(\gate,0);

		~vibLoop.stop;
		~marLoop.stop;
		~gloLoop.stop;
		~stopFields.value();
		~stopImprov.value();

	},//
	//

	{ //// Section 5 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Biological Conclusion".postln;
		// "Home for the Dying Article".
		"Predeceased face scanner".postln;
		~bioConcCoherence = 0;
		//
		// Swamp song and heights call synths
		~bioConcSynth1 = Synth(\bufferPlayerMono, [\bufnum, ~voxBioConc[0], \attack, 0.05,\pan,(rrand(-100,100)/100),
			\release, 5 , \gate, 1, \amp,  ~masterLevelMedium, \loop, 1,\out,~voxOutput]);
		~bioConcSynth1.run(false);

		~bioConcSynth2 = Synth(\bufferPlayerMono, [\bufnum, ~voxBioConc[1], \attack, 0.05,\pan,(rrand(-100,100)/100),
			\release, 5 , \gate, 1, \amp,  ~masterLevelMedium, \loop, 1,\out,~voxOutput]);
		~bioConcSynth2.run(false);

		if (~sectionDepth[5] > 1, {
		~bioConcSusurus = Synth(\bufferPlayer, [\bufnum, ~voxBioConc[2], \attack, 0.05,\pan,(rrand(-100,100)/100),
			\release, 5 , \gate, 1,\amp,  ~masterLevelMedium * 0.5 * (1 - ~bioConcCoherence), \loop, 1,\out,~backgroundOutput]);
		~bioConcSusurus.run(true);

		// Need to respond to Benjamin's Coherence to turn up the susurus synth
		~bioConcCohResponder.remove;
		~bioConcCohResponder = OSCresponderNode(nil, '/coherence', {|t, r, msg|
			// special Coherence responder to react to benjamins values
			if (msg[1] == 0, {
				//("Setting Bio CONC Whispers: " ++ msg[2]).postln;
				~bioConcCoherence = sqrt(msg[2]); // changes length of vocal slices
				~bioConcSusurus.set(\amp, ~masterLevelMedium * 0.8 * (1 - ~bioConcCoherence));
			});
		}).add;
		});

		~bioConcResponder.remove;
		~bioConcResponder = OSCresponderNode(nil, '/trig', {|t, r, msg|
			if (msg[1] == 0, {
				("Setting BIO CONC synths: " ++ msg[2]).postln;
				// cover the change with a sound
				{
					var sound = SinOsc.ar([midicps((3.rand) + 60),midicps((5.rand) + 61)], 0,
									    EnvGen.ar(Env.perc((5 / 10), 0.3, ~masterLevelVeryLow, 4),1,
									    doneAction: 2));
					Out.ar(~voxOutput,sound)
				}.play;

				// set the synths to the correct levels
				if (msg[2] == 1, {
					("ALIVE detected, play Heights call").postln;
					~bioConcSynth1.run(true);
					~bioConcSynth2.run(false);
					//~bioConcSusurus.run(false);
				});
				if (msg[2] == 0, {
					("DEAD detected, play Swamp Song").postln;
					("Death Coherence =" + ~bioConcCoherence);
					~bioConcSynth1.run(false);
					~bioConcSynth2.run(true);
					//~bioConcSusurus.run(true);
				});
			});
		}).add;


		~vibLoop.play;
		~marLoop.play;

		~loopChord3.value();
		~startFields.value();

		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		~setImprovVibes.value();
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		// Background sounds volume is "very low"
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelVeryLow);

		~bioConcEnd.remove;
		~bioConcEnd = OSCresponderNode(nil, '/sectionend', {|t, r, msg|
			("End of BioConc" + ~masterDepth).postln;
			~bioConcSynth1.set(\gate,0);
			~bioConcSynth2.set(\gate,0);
			~bioConcSusurus.set(\gate,0);
		}).add;

	},{
		"END: Biological Conclusion".postln;
		~buzzingMotors = false;
		~bioConcSynth1.set(\gate,0);
		~bioConcSynth2.set(\gate,0);
		~bioConcSusurus.set(\gate,0);
		~bioConcResponder.remove;
		~bioConcCohResponder.remove;

		~vibLoop.stop;
		~marLoop.stop;
		~stopFields.value();
		~stopImprov.value();
		~bioConcEnd.remove;
	},//
	//

	{ //// Section 6 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Transcendence Exposition".postln;
		"Dying Line...".postln;
		//~voxDyingPlay.set(\on,1);

		~transExpSynth1 =
			Synth (\lmtdVocalPlayer, [\bufnum, ~voxTransExp[0], \pan,(rrand(-100,100)/100),
			\coherence, ~masterCoherence.asMap, \masterLevel, ~masterLevelBus.asMap,\amp,~masterLevelMedium,
			\on, 1,\out,~backgroundOutput]);

		~transExpSynth2 =
			Synth (\lmtdVocalPlayer, [\bufnum, ~voxTransExp[1], \pan,(rrand(-100,100)/100),
			\coherence, ~masterCoherence.asMap, \masterLevel, ~masterLevelBus.asMap,\amp,~masterLevelMedium,
			\on, 1,\out,~backgroundOutput]);

		//~localAddress.sendMsg("/updatesounds", 0.5, 0.5, 1, ~masterLevelMedium);


		//~vibLoop.play;
		//~marLoop.play;
		~gloLoop.play;
		~loopCrazy.value();
		~startFields.value();


		~buzzingMotors = false;

		// set Background sounds params
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelLow);

		~transExpEnd.remove;
		~transExpEnd = OSCresponderNode(nil, '/sectionend', {|t, r, msg|
			("End of TransExp" + ~masterDepth).postln;
			~transExpSynth1.set(\on,0);
			~transExpSynth2.set(\on,0);
		}).add;

	},{
		"END: Transcendence Exposition".postln;
		~buzzingMotors = false;
		~transExpSynth1.set(\on,0);
		~transExpSynth2.set(\on,0);
		~transExpSynth1.free;
		~transExpSynth2.free;

		//~vibLoop.stop;
		//~marLoop.stop;
		~gloLoop.stop;
		~stopFields.value();
		~stopImprov.value();

		~transExpEnd.remove;
	},//
	//

	{ //// Section 7 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Transcendence Climax".postln;
		"Train station".postln;

		~vibLoop.play;
		//~marLoop.play;
		~gloLoop.play;
		~loopChord3.value();
		~loopCrazy.value();
		~startFields.value();


		~buzzingMotors = false;

		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		~setImprovMarimba.value();
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		// set Background sounds params
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelVeryLow);
	},{
		"END: Transcendence Climax".postln;
		~buzzingMotors = false;
		~vibLoop.stop;
		//~marLoop.stop;
		~gloLoop.stop;
		~stopFields.value();
		~stopImprov.value();

	},//
	//

	{ ///// Section 8 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Transcendence Conclusion".postln;
		"HeLa monologue in voice over.".postln;
		~buzzingMotors = false;	// no motors
		//if(~sectionDepth[8] > 3, {~buzzingMotors = true});
		~arduinoSounds = false;

		~transConcSynth = Synth(\bufferPlayerMono, [\bufnum, ~voxTransConc, \attack, 0.05, \release, 10, \gate, 1,\amp,~masterLevelMedium,\out,~voxOutput,\pan,(rrand(-100,100)/100)]);

		~vibLoop.play;
		~marLoop.play;
		~gloLoop.play;
		~loopExtraCrazy.value();
		~startFields.value();

		// Auto improvise
		// maybe this should be on/off depending on installation mode... or just some scenes..
		~setImprovMarimba.value();
		switch (3.rand,
			0, {~startOneImprov.value();
				"Starting one improvisor".postln;},
			1, {~startTwoImprov.value();
				"Starting two improvisors".postln;},
			2, {~stopImprov.value();
				"No improvisors".postln;}
		);

		// set Background sounds params
		~localAddress.sendMsg("/updatesounds", -1, -1, -1, ~masterLevelVeryLow);
	},{
		"END: Transcendence Conclusion".postln;
		~buzzingMotors = false;
		~transConcSynth.set(\gate,0);

		~vibLoop.stop;
		~marLoop.stop;
		~gloLoop.stop;
		~stopFields.value();
		~stopImprov.value();


	},//
	//
	{ //// Section 9 ////
		///////////////////	///////////////////	///////////////////
		///////////////////
		"SECTION: Pre and Post Show".postln;
		~buzzingMotors = true; // for testing! yay!
		~arduinoSounds = true; // for testing! yay!

		// citizen announcement for show start
		~initVoxSynth = Synth(\bufferPlayer, [\bufnum, ~voxCitizen, \attack, 0.05, \release, 5 , \gate, 1,\amp,~masterLevelMedium]);
		~marLoop.play;
		~startFields.value();

		// Change Volume to "LOW"
		~localAddress.sendMsg("/updatesounds", 1, 0.2, 0.1, ~masterLevelVeryLow);

		// Set the show state to initial.
		~masterDepth = 0;
		~sectionDepth = [0,0,0,0,0,0,0,0,0,0];
	},{
		"END: Pre and Post Show".postln;
		~buzzingMotors = false;
		~initVoxSynth.set(\gate,0);
		~marLoop.stop;
		~stopFields.value();
		~stopImprov.value();

	}//
];

//
//	These functions provide some controls of level, coherence and density over the course of a performance.
//   Implement ALL of this stuff as OSC send messages! that way, BEN and HANNA can see it and I can handle all the synth sending etc in an OSC responder node.
//
~sectionEndActions = [
		{
		// Depth 0 - Opening
			~localAddress.sendMsg("/updatesounds", 0.3, 0.9, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.3, 0.9, -1, ~masterLevelVeryLow);
			~arduinoSounds = false;
			~buzzingMotors = false;
		},{
		// Depth 1
			~localAddress.sendMsg("/updatesounds", 0.4, 0.7, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.4, 0.7, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 2
			~localAddress.sendMsg("/updatesounds", 0.7, 0.6, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.7, 0.6, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 3
			~localAddress.sendMsg("/updatesounds", 0.95, 0.7, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.95, 0.7, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 4
			~localAddress.sendMsg("/updatesounds", 0.9, 0.98, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.9, 0.98, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 5
			~localAddress.sendMsg("/updatesounds", 0.8, 0.9, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.8, 0.9, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 6
			~localAddress.sendMsg("/updatesounds", 0.1, 1, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.1, 1, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 7
			~localAddress.sendMsg("/updatesounds", 0.1, 0.8, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.1, 0.8, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 8
			~localAddress.sendMsg("/updatesounds", 0.4, 1, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 0.4, 1, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		},{
		// Depth 9 - Ending
			~localAddress.sendMsg("/updatesounds", 1, 1, -1, ~masterLevelVeryLow);
			~localAddress.sendMsg("/sendupdates", 1, 1, -1, ~masterLevelVeryLow);
			~buzzingMotors = false;
			~arduinoSounds = false;
		}
	];

	