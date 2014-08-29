//
~startOneImprov.value();
~startTwoImprov.value();
~stopImprov.value();
~setImprovVibes.value();
~setImprovMarimba.value();


//

(
s.waitForBoot({
(
~mainPath = "/Users/charles/Music/SC/lmtd2010/";
thisProcess.interpreter.executeFile(~mainPath ++ "lmtdSynthDefs.scd");
~voxOutput = 0;
~backgroundOutput = 0;
~mainOutput = 0;
~mainChannels = 2;

// Load marimba improvisations
~vibraphoneImprovBufs = [
	Buffer.read(s, ~mainPath ++ "vibeImprov/1.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/2.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/3.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/4.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/5.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/6.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/7.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/8.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/9.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/10.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/11.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/12.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/13.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/14.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/15.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/16.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/17.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/18.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/19.aif"),
	Buffer.read(s, ~mainPath ++ "vibeImprov/20.aif")
];

~marimbaImprovBufs = [
	Buffer.read(s, ~mainPath ++ "marimbaImprov/1.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/2.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/3.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/4.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/5.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/6.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/7.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/8.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/9.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/10.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/11.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/12.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/13.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/14.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/15.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/16.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/17.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/18.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/19.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/20.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/21.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/22.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/23.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/24.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/25.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/26.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/27.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/28.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/29.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/30.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/31.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/32.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/33.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/34.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/35.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/36.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/37.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/38.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/39.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/40.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/41.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/42.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/43.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/44.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/45.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/46.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/47.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/48.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/49.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/50.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/51.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/52.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/53.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/54.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/55.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/56.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/57.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/58.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/59.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/60.aif"),
	Buffer.read(s, ~mainPath ++ "marimbaImprov/61.aif")
];

(
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

~rMarImprov = Pxrand(~marimbaImprovBufs,inf);
~rVibeImprov = Pxrand(~vibraphoneImprovBufs,inf);
);


//
	// Pbinds for Field recordings.
	//
	//
	~marImp1= Pbindef(\marimbaImprov1, \instrument, \bindEnv, \bufnum, ~rMarImprov, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5* ~rel, \dur, 20 * ~dur4, \amp, 0.5 * 1, \bufrate, 1, \pan,~pans, \out, 0);
	~marImp2= Pbindef(\marimbaImprov2, \instrument, \bindEnv, \bufnum, ~rMarImprov, \startpos, ~starts2, \sus, 30 * ~starts, \release, 5*  ~rel, \dur, 20 * ~dur3, \amp, 0.5 * 1, \bufrate, 1, \pan,~pans, \out, 0);
	//
	// Adjust field recording parameters
	~fieldParams = {
		arg coherence, density, movement, level;
		var amp = 0.2 + (level * 0.5);
		var rel = (5 * coherence) + 0.5;
		var sus = (30 * coherence * density) + 0.5;
		var dur = (20 * coherence * density) + 1;
		var rate = if (coherence > 0.3, {1},{~rateMid});
		
		Pbindef(\marimbaImprov1, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur4, \bufrate, rate, \out, ~backgroundOutput);
		Pbindef(\marimbaImprov2, \sus, sus*~starts, \release, rel*~rel, \dur, dur*~dur3, \bufrate, rate, \out, ~backgroundOutput);
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
		~marImp2.play;
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
)

});
	
)
