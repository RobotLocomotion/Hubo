'''
Author: alexc89@mit.edu
ListenerCommandMatlab
Used to test if hubo ref is being published on lcm across the multicast by monitoring on the of variables.  In this case, the position of the joint LSP.

'''
import lcm
import hubo_ach as ha
import time
import ach

from lcmtype import lcmt_hubo2input



def my_handler(channel, data):
    msg = lcmt_hubo2input.lcmt_hubo2input.decode(data)
    print("   commandLSP    = %s" % str(msg.LeftShoulderPitch))
    

lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=1")
subscription = lc.subscribe("HuboInput", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)
