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
import lcmt_hubo2state as lcmt




#Message Conversion
def convertLCM_Matlab(x):
    msg = lcmt.lcmt_hubo2state()
    msg.timestamp =  time.time()
    
    #Baselink state not included
    msg.NKY = x.joint[ha.NKY].pos
    msg.NKYdot = x.joint[ha.NKY].vel
#
#    msg.HNP = x.joint[ha.HNP].pos
#    msg.HNPdot = x.joint[ha.HNP].vel
#
#    msg.HNR = x.joint[ha.HNR].pos
#    msg.HNRdot = x.joint[ha.HNR].vel
#
    msg.LSP = x.joint[ha.LSP].pos
    msg.LSPdot = x.joint[ha.LSP].vel

    msg.LSR = x.joint[ha.LSR].pos
    msg.LSRdot = x.joint[ha.LSR].vel

    msg.LSY = x.joint[ha.LSY].pos
    msg.LSYdot = x.joint[ha.LSY].vel

    msg.LEB = x.joint[ha.LEB].pos
    msg.LEBdot = x.joint[ha.LEB].vel

    msg.LWY = x.joint[ha.LWY].pos
    msg.LWYdot = x.joint[ha.LWY].vel

    msg.LWP = x.joint[ha.LWP].pos
    msg.LWPdot = x.joint[ha.LWP].vel

    msg.RSP = x.joint[ha.RSP].pos
    msg.RSPdot = x.joint[ha.RSP].vel

    msg.RSR = x.joint[ha.RSR].pos
    msg.RSRdot = x.joint[ha.RSR].vel

    msg.RSY = x.joint[ha.RSY].pos
    msg.RSYdot = x.joint[ha.RSY].vel

    msg.REB = x.joint[ha.REB].pos
    msg.REBdot = x.joint[ha.REB].vel

    msg.RWY = x.joint[ha.RWY].pos
    msg.RWYdot = x.joint[ha.RWY].vel

    msg.RWP = x.joint[ha.RWP].pos
    msg.RWPdot = x.joint[ha.RWP].vel

    msg.leftThumbKnuckle3 = x.joint[ha.LF1].pos
    msg.leftThumbKnuckle3dot = x.joint[ha.LF1].vel

    msg.leftIndexKnuckle3 = x.joint[ha.LF2].pos
    msg.leftIndexKnuckle3dot = x.joint[ha.LF2].vel

    msg.leftMiddleKnuckle3 = x.joint[ha.LF3].pos
    msg.leftMiddleKnuckle3dot = x.joint[ha.LF3].vel

    msg.leftRingKnuckle3 = x.joint[ha.LF4].pos
    msg.leftRingKnuckle3dot = x.joint[ha.LF4].vel

    msg.leftPinkyKnuckle3 = x.joint[ha.LF5].pos
    msg.leftPinkyKnuckle3dot = x.joint[ha.LF5].vel

    msg.rightThumbKnuckle3 = x.joint[ha.RF1].pos
    msg.rightThumbKnuckle3dot = x.joint[ha.RF1].vel

    msg.rightIndexKnuckle3 = x.joint[ha.RF2].pos
    msg.rightIndexKnuckle3dot = x.joint[ha.RF2].vel

    msg.rightMiddleKnuckle3 = x.joint[ha.RF3].pos
    msg.rightMiddleKnuckle3dot = x.joint[ha.RF3].vel

    msg.rightRingKnuckle3 = x.joint[ha.RF4].pos
    msg.rightRingKnuckle3dot = x.joint[ha.RF4].vel

    msg.rightPinkyKnuckle3 = x.joint[ha.RF5].pos
    msg.rightPinkyKnuckle3dot = x.joint[ha.RF5].vel

    msg.WST = x.joint[ha.WST].pos
    msg.WSTdot = x.joint[ha.WST].vel


    msg.LHY = x.joint[ha.LHY].pos
    msg.LHYdot = x.joint[ha.LHY].vel

    msg.LHR = x.joint[ha.LHR].pos
    msg.LHRdot = x.joint[ha.LHR].vel

    msg.LHP = x.joint[ha.LHP].pos
    msg.LHPdot = x.joint[ha.LHP].vel

    msg.LKN = x.joint[ha.LKN].pos
    msg.LKNdot = x.joint[ha.LKN].vel

    msg.LAP = x.joint[ha.LAP].pos
    msg.LAPdot = x.joint[ha.LAP].vel

    msg.LAR = x.joint[ha.LAR].pos
    msg.LARdot = x.joint[ha.LAR].vel

    msg.RHY = x.joint[ha.RHY].pos
    msg.RHYdot = x.joint[ha.RHY].vel

    msg.RHR = x.joint[ha.RHR].pos
    msg.RHRdot = x.joint[ha.RHR].vel

    msg.RHP = x.joint[ha.RHP].pos
    msg.RHPdot = x.joint[ha.RHP].vel

    msg.RKN = x.joint[ha.RKN].pos
    msg.RKNdot = x.joint[ha.RKN].vel

    msg.RAP = x.joint[ha.RAP].pos
    msg.RAPdot = x.joint[ha.RAP].vel
    msg.RAR = x.joint[ha.RAR].pos
    msg.RARdot = x.joint[ha.RAR].vel

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
        time.sleep(0.1)
    #ACH LCM terminate
    c.close()
