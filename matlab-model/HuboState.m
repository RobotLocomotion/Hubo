classdef HuboState < LCMCoordinateFrame
  properties (GetAccess = public, SetAccess = private)
      aggregator
      robot_ptr
      x
      t
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
      defaultChan = 'HuboState';
      obj.aggregator = lcm.lcm.MessageAggregator();
      lc.subscribe(defaultChan, obj.aggregator);
    end
%     function obj = subscribe(obj,channel)
%         chash = java.lang.String(channel).hashCode();
%         if ~any(chash==obj.subscriptions)
%             %Hubo specific Code Begin
%             subscribe@Singleton(channel,obj.aggregator);
%             %Hubo specific Code End
%             obj.subscriptions(end+1)=chash;
%         end
%     end
    function [x,t] = getNextMessage(obj,timeout)
        m = obj.aggregator.getNextMessage(timeout);%Assuming timeout in milliseconds
        msg = hubo.hubo_hubo2state(m.data);
        %Conversion from msg to x and t.
%         disp(sprintf('decoded message:\n'))
%         disp([ 'NKY:   ' sprintf('%d ', m.NKY) ])
%         disp([ 'LSP(POS):    ' sprintf('%f ', m.LSP) ])
%         disp([ 'LSP(VEL): ' sprintf('%f ', m.LSPdot) ])
%         disp([ 'LSR(POS):      ' sprintf('%f ', m.LSR) ])
%         %disp([ 'name:        ' m.name ])
%         disp([ 'LSR(VEL):     ' sprintf('%d ', m.LSRdot) ])
        if length(msg) > 0
            x = msg.state    
            t = msg.timestamp;
            obj.x = x;
            obj.t = t;
        end
    end
    function [x,t] = getCurrentValue(obj)
        x = obj.x;
        t = obj.t;
    end
    function channel = defaultChannel(obj)
        channel = obj.defaultChan;
    end
  end
end
