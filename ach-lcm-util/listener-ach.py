import lcm
import hubo_ach as ha

from hubo import hubo_state

def my_handler(channel, data):
    msg = hubo_state.decode(data)
    print("   positionRF2    = %s" % str(msg.joint[ha.RF2].pos))

lc = lcm.LCM()
subscription = lc.subscribe("EXAMPLE", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)
