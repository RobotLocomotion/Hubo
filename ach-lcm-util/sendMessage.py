'''
Author: LCM
SendMessage
This is the example demo script that is already contained in the LCM Pacakage.
'''

import lcm
import time

from lcmtypes import example_t

lc = lcm.LCM()

msg = example_t()
msg.timestamp = int(time.time() * 1000000)
msg.position = (1, 2, 3)
msg.orientation = (1, 0, 0, 0)
msg.ranges = range(15)
msg.num_ranges = len(msg.ranges)
msg.name = "example string"
msg.enabled = True

lc.publish("EXAMPLE", msg.encode())
