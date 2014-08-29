// Plan:
// take average of the last 10 MIDI Velocities.
// 
// 

var lastMidiVelocity = 0;
var velocityList = List[1,2,3];
var output;

var deliverVelocityOutput = {arg value;
	// send to everybody yay!
	// sending as density values... that makes most sense I think?
	~broadcastAddress.sendMsg("/movement", 1, value);
	//("Movement Output:" + value).postln;
};

~recordMidiVelocity = {arg vel;
	var average = 0;
	
	// add the new duration to the list and pop the oldest value
	velocityList.addFirst(vel);
	velocityList.pop;
	// calculate the average and return it
	
	for(0,2,{arg i;
		average = average + velocityList[i];
	});
	average = average / 3;
	output = average / 127;
	//output = output*output;
	output.clip2(1);
	
	// deliver output to something?
	// send an OSC message?
	// who knows?
	deliverVelocityOutput.value(output);
	
	// debug
	//("MIDI Velocity Average:" + output).postln;
};


~processVelocitySilence = {
	var average = 0;
	
	// add the new duration to the list and pop the oldest value
	velocityList.addFirst(0);
	velocityList.pop;
	// calculate the average and return it
	
	for(0,2,{arg i;
		average = average + velocityList[i];
	});
	average = average / 3;
	output = average / 127;
	//output = output*output;
	output.clip2(1);
	
	// deliver output to something?
	// send an OSC message?
	// who knows?
	deliverVelocityOutput.value(output);
	
	// debug
	//("MIDI Velocity Average:" + output).postln;
	//velocityList.postln;
};



// need a routine to run the MIDI silence processor.
~velocitySilenceRoutine.stop;
~velocitySilenceRoutine = Routine {
	loop {
		~processVelocitySilence.value();
		2.yield;
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