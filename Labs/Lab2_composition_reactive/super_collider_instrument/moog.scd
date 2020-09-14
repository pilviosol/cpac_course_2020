
(
SynthDef("moog", {
	arg vibr=0, cutoff=0.5, midinote=60, amp=0;
	var osc1, osc2, osc3, f0, vib_int, cutoff_freq, fil_osc, freq;

	freq=midicps(midinote);
	f0=exp(vibr*0.035)*freq;

	osc1=Saw.ar(f0*1.0013);
	osc2=Saw.ar(f0*0.998);
	osc3=Saw.ar(f0*0.5);


	cutoff_freq=((cutoff+0.5)*6)*freq;

	fil_osc=BLowPass.ar(in:osc1+osc2+osc3, freq:cutoff_freq);
	Out.ar([0,1], amp*fil_osc);}).add;
)

// SETTING the instrument as a global variable
(
~instr=Synth(\moog);
)

// setting the note
(
~instr.set(\midinote, 62, \amp, 1);
)

//setting the cutoff
(
~instr.set(\cutoff, 3);
)


// Use this command to start the server
NetAddr("127.0.0.1",57120);



(
OSCdef('OSCreceiver',
	{
		arg msg;
		var note, amp;

		msg.postln;
		note=msg[1];
		amp=msg[2];
		~instr.set(\midinote,note, \amp,amp);
	},
	"/note");
)

(
OSCdef('OSCreceiver',
	{
		arg msg;
		var vibr, cutoff;

		msg.postln;
		cutoff=msg[1];
		vibr=msg[2];
		~instr.set(\cutoff,cutoff, \vibr, vibr);
	},
	"/effect");
)



(
OSCdef('OSCreceiver',
	{
		arg msg;
		var vibr, cutoff, amp, note;

		msg.postln;

		note=msg[1];
		amp=msg[2];
		cutoff=msg[3];
		amp=msg[4];
		instr.set(\cutoff,cutoff, \vibr, vibr, \amp,amp, \midinote, note);
	},
	"/note_effect");
)



(
var instr=Synth(\moog);
OSCdef('OSCreceiver',
	{
		arg msg;
		var note,amp;

		msg.postln;
		note=msg[1];
		amp=msg[2];
		instr.set(\midinote,note, \amp,amp);
	},
	"/note");
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








