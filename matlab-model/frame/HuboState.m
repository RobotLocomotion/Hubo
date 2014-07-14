classdef HuboState < LCMCoordinateFrame
  properties (GetAccess = public, SetAccess = private)
      aggregator
      robot_ptr
      x
      t
      defaultChannel
  end
  methods
    function obj = HuboState(r)
      typecheck(r,'TimeSteppingRigidBodyManipulator');
          
      num_u = getNumStates(r);
      dim = num_u;
      
      obj = obj@LCMCoordinateFrame('HuboState',dim,'x');
      if obj.robot_ptr == 0
        obj.robot_ptr = r;
      end
      lc = lcm.lcm.LCM.getSingleton();
      obj.defaultChannel = 'HuboState';
      obj.aggregator = lcm.lcm.MessageAggregator();
      lc.subscribe(obj.defaultChannel, obj.aggregator);
      obj.setLCMCoder(HuboStateEncoder(obj.getCoordinateNames()))
    end
    function chan = defaultChan(obj) 
        chan = obj.defaultChannel;
    end
    
    function [x,t] = getNextMessage(obj,timeout)
        data = obj.aggregator.getNextMessage(timeout);%Assuming timeout in milliseconds
        [x,t ] = obj.lcmcoder.decode(data);
        obj.x = x;
        obj.t = t;
    end
    function [x,t] = getCurrentValue(obj)
        x = obj.x;
        t = obj.t;
    end
  end
end