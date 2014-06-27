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


if __name__ == "__main__":
    #Setup ACH LCM channels
    lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=2")
    #Setup ACH
    c = ach.Channel(ha.HUBO_CHAN_STATE_NAME)#HuboState
    c. flush()

    while True:  #constant Transmission        
        #Grab a frame form ACH
        state = ha.HUBO_STATE()
        [status, framesize] = c.get(state, wait=True, last=False)
        if status == ach.ACH_OK or status == ach.ACH_MISSED_FRAME:
            x =1#print "ACH grab successful" #Testing Probe 1
        else:
            raise ach.AchException( c.result_string(status))
        
        
        #ACH to LCM conversion
        msg = convertLCM_Matlab(state)
#        msg.imu = [convert_imu(x) for x in state.imu]
#        msg.ft = [convert_ft(x) for x in state.ft]
#        msg.joint = [convert_joint_state(x) for x in state.joint]
#        msg.status = [convert_joint_status(x) for x in state.status]
#        msg.driver = [convert_jmc_state(x) for x in state.driver]
#        msg.power = convert_power(state.power)
#        msg.time = state.time
#        msg.refWait = state.refWait
        
        #Pushout an LCM message
        lc.publish("HuboState", msg.encode())
        #Loop Delay
        time.sleep(0.01)
    #ACH LCM terminate
    c.close()
