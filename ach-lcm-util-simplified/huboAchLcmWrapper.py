'''
Author: alexc89@mit.edu
SendMessageAchMatlab
Used to multicast Hubo's status on LCM.  It will take the information received on ACH and convert it to LCM.  This is needed for live visualization.

'''

import lcm
import time
import ach
import hubo_ach as ha
import time
from ctypes import *
import threading 
#Import LCM Messages
from lcmtypes import hubo_hubo2state




#Message Conversion
def convertLCM_Matlab(x):
    NUM_JOINT = 40
    msg = hubo_hubo2state()
    msg.timestamp =  time.time()
    msg.state = [0,0,0,0,0,0] #Basic Link Position
    msg.state += [x.joint[i].pos for i in range(NUM_JOINT)] #Moter joints positions
    msg.state += [0,0,0,0,0,0] #Basic Link Velocities
    msg.state += [x.joint[i].vel for i in range(NUM_JOINT)] #Motor joint velocity
    #Retroactively adding passive finger joints and their velocity
    FINGER_JOINTPOS = [17,38] #Left and Right hand.
    FINGER_JOINTPOS = [[FINGER_JOINTPOS[hand] +2*finger for finger in range(5) ] for hand in range(2)]#Populate 5 fingers
    FINGER_JOINTPOS = FINGER_JOINTPOS[0] + FINGER_JOINTPOS[1]
    FINGER_JOINTPOS += [FINGER_JOINTPOS[finger] +1 for finger in range(len(FINGER_JOINTPOS))]#Populate 2 knuckles for each finger
    FINGER_JOINTPOS += [2*knuckles for knuckles in FINGER_JOINTPOS] #add velocity
    FINGER_JOINTPOS.sort()
    [msg.state.insert(knuckle, 0) for knuckle in FINGER_JOINTPOS] #Insert zero for the passive knuckles   position + Velocity
    return msg

def convertACH_Command(msg, ref):
    ref.LSP = msg.LSP
    print ref.LSP

class huboLCMWrapper:
    
    def __init__(self):
        self.state = ha.HUBO_STATE()
        self.ref = ha.HUBO_REF()
        self.stateChan = ach.Channel(ha.HUBO_CHAN_STATE_NAME)
        self.refChan = ach.Channel(ha.HUBO_CHAN_REF_NAME)
        self.lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=1")
        self.stateChan.flush()
        self.refChan.flush()
        self.subscription = self.lc.subscribe("HuboRef",self.command_handler)
        
    def command_handler(self,channel,data):
        msg = lcmt.lcmt_hubo2state.encode(data)
        convertACH_Command(msg,self.ref)
        self.refChan.put(self.ref)
    def broadcast_state(self):
        [status, framesize] = self.stateChan.get(self.state, wait=True, last=False)
        if not ( status == ach.ACH_OK or status == ach.ACH_MISSED_FRAME):
            raise ach.AchExpcetion(self.stateChan.result_string(status))
        #ACH to LCM conversion
        msg = convertLCM_Matlab(self.state)
        self.lc.publish("HuboState", msg.encode())

    def mainLoop(self,freq):
        pauseDelay = 1.0/freq #In Seconds.
        t = 1
        def broadcastLoop():
            while True:
                self.broadcast_state()
                time.sleep(pauseDelay)
        try:
            t = threading.Thread(target=broadcastLoop)
            t.daemon = True
            t.start()
            while True:
                time.sleep(pauseDelay)
                self.lc.handle()
        except KeyboardInterrupt:
            pass

if __name__ == "__main__":
    wrapper = huboLCMWrapper()
    print "HuboLCMWrapper finish initialization, Begin transmission to LCM"
    wrapper.mainLoop(10) #Hertz
    print "HuboLCMWrapper terminated successfully."
