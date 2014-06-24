
#!/usr/bin/env python
import hubo_ach as ha
import ach
import sys
import time
from ctypes import *


c = ach.Channel(ha.HUBO_CHAN_STATE_NAME)
state = ha.HUBO_STATE()
c.flush()
[status, framesize] = c.get( state, wait=True, last=False )
if status == ach.ACH_OK or status == ach.ACH_MISSED_FRAME:
    print state
    print "Joint =", state.joint[ha.LEB].pos
    print "Mx = ", state.ft[ha.HUBO_FT_L_FOOT].m_x
else:
    raise ach.AchException( c.result_string(status) )
c.close()
