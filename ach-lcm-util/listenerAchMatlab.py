import lcm
import hubo_ach as ha
import time
import ach

import lcmt_hubo2state as lcmt

def my_handler(channel, data):
    msg = lcmt.lcmt_hubo2state.decode(data)
    print("   positionLSP    = %s" % str(msg.LSP))
    

lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=2")
subscription = lc.subscribe("EXAMPLE", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)
