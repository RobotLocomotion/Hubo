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
          
          obj = obj@LCMCoordinateFrame('HuboRef',dim,'x');
          if obj.robot_ptr == 0
            obj.robot_ptr = r;
          end
          defaultChan = 'HuboRef';
        end
        function publish(obj,t,x,channel)
            
            msg = hubo.hubo_hubo2input();
            msg.timestamp = t;
            %State Conversion
            msg.motors = x
            lcm.lcm.LCM('udpm://239.255.76.67:7667?ttl=1').publish('HuboRef', msg);
        
        end
    end
    
end
