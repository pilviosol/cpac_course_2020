import random

from constants import STATUS_START



def simple_next(status):
	if status.current ==STATUS_START: # start
		status.midinote=60
		status.dur =1
		status.BPM = 120
		status.amp = 1
		status.current=0
	elif status.current==0:
		status.midinote=status.midinote+1
		if status.midinote==84:
			status.current=1
	elif status.current==1:
		status.midinote -=1
		if status.midinote==60:
			status.current = 0
	
def map_(x_in, range_in, range_out):
	x_out = (x_in-range_in[0])/(range_in[1]-range_in[0])
	x_out = range_out[0]+ x_out * (range_out[1]-range_out[0])
	return min(max(x_out, range_out[0]), range_out[1]) 

def gingerbread(status):
	def next_gingerbread(status):
		old_x=status.pars["x"]
		status.pars["x"]=1-status.pars["y"]+abs(status.pars["x"])
		status.pars["y"]=old_x
	if status.current ==STATUS_START: # start
		notes=[60, 62, 64, 67, 69, ]
		status.pars["notes"] = []
		status.pars["durs"] = [1, .5, .25, .25]

		for octave in range(-2,3):
			for note in notes:
				status.pars["notes"].append(octave*12+note)
		status.pars["range_y"]=[-3, 8]
		status.pars["y"]=0.1
		status.pars["x"]=-0.1
		i=map_(status.pars["y"], 
		               status.pars["range_y"], 
		               [0, len(status.pars["notes"])])
		status.midinote=status.pars["notes"][int(i)]
		
		status.dur = status.pars["durs"][0]
		status.pars["count"]=1
		status.BPM = 120
		status.amp = 1
		status.current=0
	elif status.current==0:
		next_gingerbread(status)
		i=map_(status.pars["y"], 
		               status.pars["range_y"], 
		               [0, len(status.pars["notes"])])
		status.midinote=status.pars["notes"][int(i)]
		status.pars["count"]=status.pars["count"]%len(status.pars["durs"])
		status.dur = status.pars["durs"][status.pars["count"]]
		status.pars["count"]+=1
	
def gingerbread_randomness(status):
	def next_gingerbread(status):
		old_x=status.pars["x"]
		status.pars["x"]=1-status.pars["y"]+abs(status.pars["x"])
		status.pars["y"]=old_x
	if status.current ==STATUS_START: # start
		notes=[60, 62, 64, 67, 69, ]
		status.pars["notes"] = []
		status.pars["durs"] = [1, .5, .25, .25]

		for octave in range(-2,3):
			for note in notes:
				status.pars["notes"].append(octave*12+note)
		status.pars["range_y"]=[-3, 8]
		status.pars["y"]=0.1
		status.pars["x"]=-0.1
		i=map_(status.pars["y"], 
		               status.pars["range_y"], 
		               [0, len(status.pars["notes"])])
		status.midinote=status.pars["notes"][int(i)]
		
		status.dur = status.pars["durs"][0]
		status.pars["count"]=1
		status.pars["offset"]=0
		status.BPM = 120
		status.amp = 1
		status.current=0
	elif status.current==0:
		next_gingerbread(status)
		i=map_(status.pars["y"], 
		               status.pars["range_y"], 
		               [0, len(status.pars["notes"])])
		if random.random()<0.1: #5% probability
			status.pars["offset"]=random.random()*len(status.pars["notes"])
						

		i=(i+status.pars["offset"])%len(status.pars["notes"])
		status.midinote=status.pars["notes"][int(i)]
		status.pars["count"]=status.pars["count"]%len(status.pars["durs"])
		status.dur = status.pars["durs"][status.pars["count"]]
		status.pars["count"]+=1



