import lcm
import hubo_ach as ha
from lcmtypes import hubo_hubo2state

def my_handler(channel, data):
    msg = hubo_hubo2state.decode(data)
    print("   positionRF2    = %s" % str(msg.state[ha.RF2].pos))
    print("   velocityRF2    = %s" % str(msg.state[ha.RF2*2].pos))

lc = lcm.LCM("udpm://239.255.76.67:7667?ttl=1")
subscription = lc.subscribe("HuboState", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)
