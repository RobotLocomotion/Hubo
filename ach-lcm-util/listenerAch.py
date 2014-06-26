import lcm
import hubo_ach as ha
from lcmtypes import lcmt_hubo2state

def my_handler(channel, data):
    msg = lcmt_hubo2state.decode(data)
    print("   positionRF2    = %s" % str(msg.joint[ha.RF2].pos))

lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=1")
subscription = lc.subscribe("HuboRef", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)
