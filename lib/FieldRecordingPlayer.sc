//
//	Field Recording Player
//	
//	for The Last Man to Die
//
//	Charles Martin, 2010.
//
FieldRecordingPlayer	{
	// Tech
	var <>out;			// Output bus. Defaults to zero unless given other
	var fieldClock;		// Tempo clock to schedule sound changes.
	// Sounds
	var <bufferArray;		// Array of buffers passed on creation
	var <bufSynthArray;	// Array of currently playing synths (2)
	var <playSlots;		// Array of depths for currently playing buffers (2)
	// Buses
	var <levelBus;		// Bus of master level
	var <coherenceBus;		// Bus of master coherence - how sensible the sound is
	var <densityBus;		// Bus of master density - how often sound events occur
	var <>depth;			// Bus of master depth - controls how many buffers play at once
	var changeFrequency; 	// Frequency in seconds of field recording changes, low/high
	//
	

	*new {
		arg bufferArrayArg, levelBusArg, coherenceBusArg, densityBusArg, depthArg = 0, outArg = 0;
			
		^super.new.init(bufferArrayArg, levelBusArg, coherenceBusArg, densityBusArg, depthArg, outArg);
	}
	
	init	{
		arg bufferArrayArg, levelBusArg, coherenceBusArg, densityBusArg, depthArg, outArg;
		// update class variables
		bufferArray = bufferArrayArg;
		playSlots = [0,0];
		out = outArg;
		levelBus = levelBusArg;
		coherenceBus = coherenceBusArg;
		densityBus = densityBusArg;
		depth = depthArg;
		changeFrequency = [120,240];
		
		// Load the field recording synthdef.
		this.loadSynthDef;
		
		// Setup the clock for scheduling
		//fieldClock = TempoClock.new(1);
		// Setup the array for Synths
		//bufSynthArray = Array.newClear(playSlots.size);
		
		// Start the field recordings.
		//this.play;
	}
	
	// Choose new field recording for a slot given as an argument.
	chooseNewField {
		arg number;
		var newBufferChoice = bufferArray.size.rand; // select a new buffer number.
				
		// Shutdown the previous Field 0 if it's playing
		if (bufSynthArray[number].notNil, 
			{ bufSynthArray[number].set(\live,0) },{});
		
		// If depth is greater than the required depth to play this slot
		// Start new synth with new buffer number
		if (depth >= playSlots[number], {
			bufSynthArray[number] = Synth(\lmtdfieldrecPlayer, [
				\bufNum, bufferArray[newBufferChoice], 
				\pan, (rrand(-100,100) / 100),
				\masterLevel, levelBus.asMap, 
				\coherence, coherenceBus.asMap, 
				\density, densityBus.asMap, 
			]);
			// Report
			("FIELD RECORDING PLAYER:		Changing Field Recording" + number).postln;
		});
		
		// Schedule the next number change
		fieldClock.sched(rrand(changeFrequency[0],changeFrequency[1]),
			{this.chooseNewField(number)}
		);
	}
	
	// Stop a field who's slot is given in the argument
	stopField {
		arg number;
		if (bufSynthArray[number].notNil, 
			{ 
				bufSynthArray[number].free; 
				("FIELD RECORDING PLAYER:		Stopped Field" + number).postln;
			},{});
	}
	
	// Start all field recordings playing
	play {
		("FIELD RECORDING PLAYER:		Playing Field Recordings...").postln;
		fieldClock = TempoClock.new(1); // Setup the clock for scheduling
		bufSynthArray = Array.newClear(playSlots.size); // Setup the array for Synths
		// Start each field recording
		(playSlots.size).do({ arg i;
		this.chooseNewField(i);
	});
	}
	
	// Clear the clock and stop all field recordings
	stop	{
		("FIELD RECORDING PLAYER:		Stopping Field Recordings...").postln;
		// Stop the Clock
		fieldClock.stop;
		fieldClock.clear;
		// Stop each field
		(playSlots.size).do({ arg i;
		this.stopField(i);
	});
	}
	
	// Stop and then Start
	reset {
		("FIELD RECORDING PLAYER:		Resetting Field Recordings...").postln;
		this.stop;
		this.start;
	}
	
	loadSynthDef {
		("FIELD RECORDING PLAYER:		Loading Field Recording SynthDef...").postln;
	}
}