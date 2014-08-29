// Plan:
// take average of the last 10 gaps between MIDI notes.
// First, measure gaps between midi notes
// 


var clock = TempoClock.default;
var lastMidiNoteTime = clock.beats;
var timeList = List[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
var maxAvDuration = 60;
var output;

~deliverOutput = {arg value;
	// send to everybody yay!
	// sending as density values... that makes most sense I think?
	~broadcastAddress.sendMsg("/density", 1, value);
	//("Density Output:" + value).postln;
};

~recordMidiNoteTime = {
	// calculate the gap between this midi note and the last
	var currentTime = clock.beats;
	var average = 0;
	var time = currentTime - lastMidiNoteTime;
	
	lastMidiNoteTime = currentTime;	
	time = time.clip2(maxAvDuration * 10);// substitue 240 for crazy big time values
	
	// add the new duration to the list and pop the oldest value
	timeList.addFirst(time);
	timeList.pop;
	// calculate the average and return it
	
	for(0,14,{arg i;
		average = average + timeList[i];
		
	});
	average = average / 15;
	average = average.clip2(maxAvDuration);
	output = 1 - (average / maxAvDuration);
	output = output*output;
	
	// deliver output to something?
	// send an OSC message?
	// who knows?
	~deliverOutput.value(output);
	
	// debug
	//("MIDI Strike density:" + output).postln;
};


~processMidiSilence = {
	// rationale here is -- periodically update the first value in the list in the case
	// of long silences... so that quick notes slowly fade away right?
	//
	//
	// calculate the gap between this midi note and the last
	var currentTime = clock.beats;
	var time = currentTime - lastMidiNoteTime;
	var average = 0;
	
	time = time.clip2(maxAvDuration * 10); // substitue 240 for crazy big time values
	
	// substitute the first value for this one
	timeList.put(0,time);

	// calculate the average and return it
	for(0,14,{arg i;
		timeList[i] = timeList[i] + 0.1;
		average = average + timeList[i];
		
	});
	average = average / 15;
	average = average.clip2(maxAvDuration);
	output = 1 - (average / maxAvDuration);
	output = output*output;
	
	// deliver output to something?
	// send an OSC message?
	// who knows?
	~deliverOutput.value(output);
	
	// debug
	//("MIDI Strike density:" + output).postln;
	//timeList.postln;
};



// need a routine to run the MIDI silence processor.
~midiSilenceRoutine.stop;
~midiSilenceRoutine = Routine {
	loop {
		~processMidiSilence.value();
		0.01.yield;
	}	
}.play

//TempoClock;
//x = 0
//x = x + y[5];
//x
//x = x.clip2(3);
//
//y = List[1,2,3,4,5,6,7,8,9,10];
//y
//y.addFirst(100);
//y.pop;