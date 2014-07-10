classdef HuboInput < LCMCoordinateFrame
    properties (GetAccess = public, SetAccess = private)
      aggregator
      robot_ptr
      x
      t
      
    end
    methods
        function obj = HuboInput(r)
          typecheck(r,'TimeSteppingRigidBodyManipulator');
          
          num_u = getNumInputs(r);
          dim = num_u;
          
          obj = obj@LCMCoordinateFrame('HuboInput',dim,'x');
          if obj.robot_ptr == 0
            obj.robot_ptr = r;
          end
          obj.setCoordinateNames(r.getInputFrame.coordinates);
          obj.setDefaultChannel('HuboInput');
          obj.setLCMCoder(HuboInputEncoder(obj.getCoordinateNames()));
        end
        function publish(obj,t,x,channel)
            
            msg = obj.lcmcoder.encode(t,x);
            lcm.lcm.LCM('udpm://239.255.76.67:7667?ttl=1').publish(channel, msg);
        
        end
    end
    
end
