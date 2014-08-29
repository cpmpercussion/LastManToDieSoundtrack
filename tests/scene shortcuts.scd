
(
~masterDepth = 0;
~sectionDepth = [0,0,0,0,0,0,0,0,0,0];
);

~localAddress.sendMsg("/section", 0);
~localAddress.sendMsg("/section", 1);
~localAddress.sendMsg("/section", 2);

~localAddress.sendMsg("/section", 3);
~localAddress.sendMsg("/section", 4);
~localAddress.sendMsg("/section", 5);

~localAddress.sendMsg("/section", 6);
~localAddress.sendMsg("/section", 7);
~localAddress.sendMsg("/section", 8);



~localAddress.sendMsg("/trig",0,1);

~localAddress.sendMsg("/trig",0,0);
~localAddress.sendMsg("/coherence",0,0.8);


~localAddress.sendMsg("/trig",0,1);
~localAddress.sendMsg("/trig",0,0);

~sectionDepth

[ 3, 1, 2, 3, 1, 2, 7, 1, 4, 0 ]