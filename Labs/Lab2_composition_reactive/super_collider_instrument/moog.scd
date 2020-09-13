
(
SynthDef("moog", {
	arg vibr=0, cutoff=0.5, midinote=60, amp=0, sustain=1;
	var osc1, osc2, osc3, f0, vib_int, cutoff_freq, fil_osc, freq;

	freq=midicps(midinote);
	f0=exp(vibr*0.035)*freq;

	osc1=Saw.ar(f0*1.0013);
	osc2=Saw.ar(f0*0.998);
	osc3=Saw.ar(f0*0.5);


	cutoff_freq=((cutoff+0.5)*6)*freq;

	fil_osc=BLowPass.ar(in:osc1+osc2+osc3, freq:cutoff_freq);
	fil_osc= fil_osc*EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	//fil_osc= fil_osc*EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 15);
	//fil_osc= fil_osc*EnvGen.kr(Env.linen(0.05, sustain, 0.1));
	Out.ar([0,1], amp*fil_osc);}).add;
)


// Test with a line of bass
(
Pbind(
    \instrument,        \moog,
    \midinote,             Pseq(12+[31, 31, 31,31, 31, 31,31, 33, 34,34,34,34,34,34,34,38,
		36,36,36,36,36,36,36,38,39,39,39,39,38,33,33,30], inf),
	\sustain,             Pseq([0.1,], inf),
	\amp,             Pseq([1,0.7,0.7,0.7], inf),
    \dur,                Pseq([0.33], inf),

).play;
)

// Test with a line of bass
(
Pbind(
    \instrument,        \moog,
    \midinote,             Pseq(12+[31, 31, 33, 34,34,38, 36,36,38,39,42,38,33,30], inf),
	\sustain,             Pseq([0.33,], inf),
	\amp,             Pseq([0.8], inf),
    \dur,                Pseq([2,0.33, 0.33, 2, 0.33, 0.33, 2, 0.33,0.33,1.33,0.33,0.33,0.33,0.33], inf),

).play;
)


//set the server
NetAddr("127.0.0.1",57120);

(
var instr;
instr=Synth(\moog);
OSCdef('OSCreceiver',
	{
		arg msg;
		var note,amp, vibr, cutoff, sustain;
		msg.postln;
		note=msg[1];
		amp=msg[2];
		vibr=msg[3];
		cutoff=msg[4];
		sustain=msg[5];
		instr.set(\midinote,note, \cutoff,cutoff, \vibr, vibr, \amp,amp, \sustain, sustain);
	},
	"/all_moog");
)



(
OSCdef('OSCreceiver',
	{
		arg msg;
		var note,amp, sustain, instr;
		instr=Synth(\moog);

		msg.postln;
		note=msg[1];
		sustain=msg[2]-0.1 ;
		amp=msg[3];

		instr.set(\midinote,note, \sustain, sustain, \amp,amp);
	},
	"/note_amp");
)
(
OSCdef('OSCreceiver',
	{
		arg msg;
		var note,sustain;
		msg.postln;
		note=msg[1];
		sustain=msg[2];

		instr.set(\midinote,note, \sustain, sustain);
	},
	"/note");
OSCdef('OSCreceiver',
	{
		arg msg;
		var vibr, cutoff, amp;
		msg.postln;
		cutoff=msg[1];
		amp=msg[2];
		vibr=msg[3];
		instr.set(\cutoff,cutoff, \vibr, vibr, \amp,amp);
	},
	"/effect_amp");
OSCdef('OSCreceiver',
	{
		arg msg;
		var vibr, cutoff;
		msg.postln;
		cutoff=msg[1];
		vibr=msg[2];
		instr.set(\cutoff,cutoff, \vibr, vibr);
	},
	"/effect");
)











