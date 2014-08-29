//
//
//	LMTD 2010 - MIDI Responder
//	cpm June 2010
//
	// MIDI Stuff;
~startMidi = {
	var inPorts = 4;
	var outPorts = 4;
	MIDIClient.init(inPorts,outPorts);	// explicitly intialize the client
	inPorts.do({ arg i; 
		MIDIIn.connect(i, MIDIClient.sources.at(i));
	});
	
	//
	// Control Numbers --- i.e. nanoKontrol
	//
	MIDIIn.control = nil;
	MIDIIn.control = {|port, chan, number, value| 
		//[port, chan, number, value].postln;
		if ((chan == 0) && (number == 0) && 
			(port == MIDIIn.findPort("nanoKONTROL", "SLIDER/KNOB").uid), {
			~localAddress.sendMsg("/coherence",0, (value / 127));
			// commented out, 2010 09 13, cpm
			//("Mix Vox: " ++ value).postln;
			//~bioConcSynth1.set(\amp, (value / 127));
			//~bioConcSynth2.set(\amp, (1 - (value / 127)));
			//value / 127
		});
		};
	
	
	// Note Counters --- i.e. MalletKat
	~buzzProbability = 0;
	~strikeCounter = 0;
	
	~malletKatResponder.remove;
	~malletKatResponder = NoteOnResponder({ |src,chan,note,vel|
			//[src,chan,note,vel].postln;
			// movement values sent by velocity counter function!
			//~broadcastAddress.sendMsg("/movement", 1, (vel/127));
			~recordMidiVelocity.value(vel);
			
			// density values sent by note counter functions
			// activate noteCounter functions!
			~recordMidiNoteTime.value();
			
			//~broadcastAddress.sendMsg("/density", 1, (note/127));
			//("	MIDI - Send /cpm/note Message:" + note + vel).postln;
			if (vel > 50, {
				// Send Arduino Buzz Message
				~strikeCounter = ~strikeCounter + 1;
				~strikeCounter = ~strikeCounter % 30;
				//("	MalletKat - Counted Strike:" + ~strikeCounter).postln;
				if (~buzzingMotors , {
					~buzzProbability = ~strikeCounter / 30;
					[{
						var motorChoice = 4.rand;
						//floor((note / 12) - 4);
						("	MalletKat - Buzzing Motor:" + motorChoice).postln;
						~strikeCounter = 0;
						~broadcastAddress.sendMsg("/ardpulse", 4.rand); // Sending Message
					}, {} ].wchoose([~buzzProbability,(1 - ~buzzProbability)]).value;
					
				});
			});
		},
		nil, // any source
		nil, // any channel
		nil, // any note
		nil // any vel
	);
	
};
	
~startMidi.value;