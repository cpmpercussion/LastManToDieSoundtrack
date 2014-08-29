//
// Load Loops
("LMTD2010 - Loading sounds, wait until server is active (shows activity in lower right of screen)").postln;
~vibesLp = [
	Buffer.read(s, ~audioPath ++ "loops/vibesLp1.aif"),
	Buffer.read(s, ~audioPath ++ "loops/vibesLp2.aif"),
	Buffer.read(s, ~audioPath ++ "loops/vibesLp3.aif")
];
~glockLp = [
	Buffer.read(s, ~audioPath ++ "loops/glockLp1.aif"),
	Buffer.read(s, ~audioPath ++ "loops/glockLp2.aif"),
	Buffer.read(s, ~audioPath ++ "loops/glockLp3.aif")
];
~marLp = [
	Buffer.read(s, ~audioPath ++ "loops/marLp1.aif"),
	Buffer.read(s, ~audioPath ++ "loops/marLp2.aif"),
	Buffer.read(s, ~audioPath ++ "loops/marLp3.aif")
];

// Load Field Recordings
~fieldRecordings = [
	//Buffer.read(s, ~audioPath ++ "fieldrecording/Japan2010-FushimiInariShrine.aif"),
	Buffer.read(s,~audioPath ++ "fieldrecording/Japan2010-Cemetary.aif"),
	Buffer.read(s,~audioPath ++ "fieldrecording/Japan2010-RainySanjoDori.aif"),
	Buffer.read(s,~audioPath ++ "fieldrecording/Japan2010-HiroshimaLine.aif"),
	Buffer.read(s,~audioPath ++ "fieldrecording/Japan2010-YamanoteLine.aif"),
	//Buffer.read(s,~audioPath ++ "fieldrecording/Japan2010-NambaWalk.aif")
];

// Load Vibes Cues
//~vibesAAll.free; ~vibesAAll= Buffer.read(s,~audioPath ++ "vibes/partA-All.aif");
//~vibesThemeB.free; ~vibesThemeB = Buffer.read(s,~audioPath ++ "vibes/themeB.aif");

// Load marimba improvisations
~vibraphoneImprovBufs = [
	Buffer.read(s, ~audioPath ++ "vibeImprov/1.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/2.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/3.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/4.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/5.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/6.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/7.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/8.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/9.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/10.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/11.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/12.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/13.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/14.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/15.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/16.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/17.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/18.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/19.aif"),
	Buffer.read(s, ~audioPath ++ "vibeImprov/20.aif")
];

~marimbaImprovBufs = [
	Buffer.read(s, ~audioPath ++ "marimbaImprov/1.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/2.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/3.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/4.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/5.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/6.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/7.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/8.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/9.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/10.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/11.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/12.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/13.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/14.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/15.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/16.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/17.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/18.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/19.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/20.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/21.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/22.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/23.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/24.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/25.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/26.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/27.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/28.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/29.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/30.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/31.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/32.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/33.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/34.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/35.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/36.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/37.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/38.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/39.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/40.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/41.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/42.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/43.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/44.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/45.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/46.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/47.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/48.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/49.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/50.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/51.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/52.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/53.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/54.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/55.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/56.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/57.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/58.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/59.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/60.aif"),
	Buffer.read(s, ~audioPath ++ "marimbaImprov/61.aif")
];

// Load Vocal cues
~voxCyberConc = [
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-1.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-2.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-3.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-4.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-5.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-6.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-7.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-8.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-9.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-10.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-11.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-12.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-13.aif"),
	Buffer.read(s,~audioPath ++ "vocal/CyberConc/CyberConc-14.aif")
];

~voxBioExp = Buffer.read(s,~audioPath ++ "vocal/BioExp/BioExp-TurritopsisNutricula.aif");
~voxBioClimax.free;
~voxBioClimax = Buffer.read(s,~audioPath ++ "vocal/BioClimax/BioClimax-AgingMonologue.aif");
~voxBioConc = [
	Buffer.read(s,~audioPath ++ "vocal/BioConc/BioConc-HeightsCall.aif"),
	Buffer.read(s,~audioPath ++ "vocal/BioConc/BioConc-SwampSong.aif"),
	Buffer.read(s,~audioPath ++ "vocal/BioConc/Susurus.aif")
];

~voxTransExp = [
	Buffer.read(s,~audioPath ++ "vocal/TransExp/TransExp-WhispersQuiet.aif"),
	Buffer.read(s,~audioPath ++ "vocal/TransExp/TransExp-WhispersLoud.aif")
];
~voxTransConc = Buffer.read(s,~audioPath ++ "vocal/TransConc/TransConc-HeLa.aif");
~voxCitizen.free; ~voxCitizen = Buffer.read(s,~audioPath ++ "vocal/WelcomeCitizen.aif");

// Load Section Cues
~sectionVox = [
	Buffer.read(s,~audioPath ++ "section/0CyberExp.aif"),
	Buffer.read(s,~audioPath ++ "section/1CyberCli.aif"),
	Buffer.read(s,~audioPath ++ "section/2CyberConc.aif"),
	Buffer.read(s,~audioPath ++ "section/3BioExp.aif"),
	Buffer.read(s,~audioPath ++ "section/4BioCli.aif"),
	Buffer.read(s,~audioPath ++ "section/5BioConc.aif"),
	Buffer.read(s,~audioPath ++ "section/6TransExp.aif"),
	Buffer.read(s,~audioPath ++ "section/7TransCli.aif"),
	Buffer.read(s,~audioPath ++ "section/8TransConc.aif"),
	nil
];

~endingVox = Buffer.read(s,~audioPath ++ "section/9Ending.aif");