//
// LMTD Gui.
//
//
//
(
~localAddress = NetAddr.new("127.0.0.1",57120);
~lmtdWindow = Window("The Last Man to Die",Rect(600,5,600,150)).front;


~startShowButton= Button(~lmtdWindow, Rect(10,10,100,25))
	.states_([["Start LMTD", Color.black, Color.green], ["Stop LMTD", Color.black, Color.red] ])
	.action_({ arg butt;
		//("BUTTON	State: ").post;
		//butt.value.postln;
		switch (butt.value,
			0, {("LMTD	The Show is stopping...").postln;
					~stopSounds.value;
				},
			1, {("LMTD	The show is starting...").postln;
					~startSounds.value;		// load all the sounds
					~startResponders.value;		// load the OSC responders
					//~localAddress.sendMsg("/section",9); // Start the initial section!
				}
		);
	});

~newSceneTestButton= Button(~lmtdWindow, Rect(120,10,100,25))
	//.states_([["End Scene", Color.black, Color.red],["New Scene", Color.black, Color.green]])
	.states_([["New Scene", Color.black, Color.red]])
	.action_({ arg butt;
		("LMTD	Choosing a new scene - (by button)").postln;
		~localAddress.sendMsg("/section",9.rand);

		//("BUTTON	State: ").post;
		//butt.value.postln;
		//switch (butt.value,
		//	1, {("LMTD	Ending a scene - (by button)").postln;
		//			~localAddress.sendMsg("/sectionend");
		//		},
		//	0, {("LMTD	Choosing a new scene - (by button)").postln;
		//			~localAddress.sendMsg("/section",9.rand);
		//		}
		//
		//);
	});

~newSceneTestButton= Button(~lmtdWindow, Rect(230,10,100,25))
	.states_([["End Scene", Color.yellow, Color.blue]])
	.action_({ arg butt;
		("LMTD	Ending a scene - (by button)").postln;
		~localAddress.sendMsg("/sectionend");
	});

~newSceneTestButton= Button(~lmtdWindow, Rect(340,10,100,25))
	.states_([["Start Scene 9", Color.blue, Color.red]])
	.action_({ arg butt;
		("LMTD	Starting Scene 9 (special)").postln;
		~localAddress.sendMsg("/section",9); // Start the initial section!
	});

~stopSoundsButton= Button(~lmtdWindow, Rect(450,10,100,25))
	.states_([["Stop Sounds", Color.blue, Color.red]])
	.action_({ arg butt;
		("Stopping Sounds by button").postln;
		~stopSounds.value();
	});

~resetCounterButton = Button(~lmtdWindow, Rect(450,45,100,25))
	.states_([["Reset Scenes", Color.white, Color.green]])
	.action_({ arg butt;
		("Reset Scene Counters").postln;
		~masterDepth = 0;
		~sectionDepth = [0,0,0,0,0,0,0,0,0,0];
	});

~variableMonitor = StaticText(~lmtdWindow, Rect(45, 45, 400, 20)).background_(Color.grey);

~sectionMonitor = StaticText(~lmtdWindow, Rect(45, 75, 400, 20)).background_(Color.white);

~installationMonitor = StaticText(~lmtdWindow, Rect(45,105,400,20)).background_(Color.white);

~updateInstallationMode = {
	Routine {
		if(~installationMode,{
			~installationMonitor.string = ("   INSTALLATION MODE ACTIVE     ");
		},{
			~installationMonitor.string = ("   PERFORMANCE MODE ACTIVE      ");
		});
	}.play(AppClock);
};

~updateInstallationMode.value();


~updateGuiCohDenMovLev = {
	Routine{
		~variableMonitor.string = ("   Coh:" + ~masterCoherenceVar.round(0.01) + "        Den:" + ~masterDensityVar.round(0.01) + "        Mov:" + ~masterMovementVar.round(0.01) + "        Lev:" + ~masterLevelVar.round(0.01));
	}.play(AppClock);
};

~updateGuiCohDenMovLev.value();

~updateGuiSection = {
	Routine{
		~sectionMonitor.string = ("   Section:" +~currentSection+ "      Section Depth:" +~sectionDepth[~currentSection] +"      Show Section Count:" + ~masterDepth);
	}.play(AppClock);
};

~updateGuiSection.value();

);
