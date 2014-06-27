'''
Author: alexc89@mit.edu
SendMessageAch
This is used to test that the conversion between ach and lcm is correct.
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
##TODOi
def convert_imu(imu):
    x = hubo_imu()
    x.a_x = imu.a_x
    x.a_y = imu.a_y
    x.a_z = imu.a_z
    x.w_x = imu.w_x
    x.w_y = imu.w_y
    x.w_z = imu.w_z
    return x
def convert_ft(ft):
    x = hubo_ft()
    x.m_x = ft.m_x
    x.m_y = ft.m_y
    x.f_z = ft.f_z
    return x
def convert_joint_state(js):
    x = hubo_joint_state()
    x.ref = js.ref
    x.comply = js.comply
    x.pos = js.pos
    x.cur = js.cur
    x.vel = js.vel
    x.duty = js.duty
    x.heat = js.heat
    x.tmp = js.tmp
    x.active = js.active
    x.zeroed = js.zeroed
    return x
def convert_joint_status(js):
    x = hubo_joint_status()
    x.ctrlOn=js.ctrlOn
    x.mode=js.mode
    x.limitSwitch=js.limitSwitch
    x.homeFlag=js.homeFlag
    x.jam=js.jam
    x.pwmSaturated=js.pwmSaturated
    x.bigError=js.bigError
    x.encError=js.encError
    x.driverFault=js.driverFault
    x.motorFail0=js.motorFail0
    x.motorFail1=js.motorFail1
    x.posMinError=js.posMinError
    x.posMaxError=js.posMaxError
    x.velError=js.velError
    x.accError=js.accError
    x.tempError=js.tempError
    return x
def convert_jmc_state(jmc):
    x = hubo_jmc_state()
    x.temp= jmc.temp
    return x
def convert_power(p):
    x=hubo_power()
    x.voltage = p.voltage
    x.current = p.current
    x.power = p.power
    return x



if __name__ == "__main__":
    #Setup ACH LCM channels
    lc = lcm.LCM()
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
        msg = hubo_state()
        msg.imu = [convert_imu(x) for x in state.imu]
        msg.ft = [convert_ft(x) for x in state.ft]
        msg.joint = [convert_joint_state(x) for x in state.joint]
        msg.status = [convert_joint_status(x) for x in state.status]
        msg.driver = [convert_jmc_state(x) for x in state.driver]
        msg.power = convert_power(state.power)
        msg.time = state.time
        msg.refWait = state.refWait
        
        #Pushout an LCM message
        lc.publish("EXAMPLE", msg.encode())
        #Loop Delay
        time.sleep(0.1)
    #ACH LCM terminate
    c.close()

