classdef HuboState < LCMCoordinateFrame
  properties (GetAccess = public, SetAccess = private)
      aggregator
      robot_ptr
      x
      t
  end
  methods
    function obj = HuboState(r)
      obj = obj@LCMCoordinateFrame('HuboState','lcmtypes.lcmt_hubo2state','x');
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
        msg = lcmtypes.lcmt_hubo2state(m.data);
        %Conversion from msg to x and t.
%         disp(sprintf('decoded message:\n'))
%         disp([ 'NKY:   ' sprintf('%d ', m.NKY) ])
%         disp([ 'LSP(POS):    ' sprintf('%f ', m.LSP) ])
%         disp([ 'LSP(VEL): ' sprintf('%f ', m.LSPdot) ])
%         disp([ 'LSR(POS):      ' sprintf('%f ', m.LSR) ])
%         %disp([ 'name:        ' m.name ])
%         disp([ 'LSR(VEL):     ' sprintf('%d ', m.LSRdot) ])
        if length(msg) > 0
            x = [msg.base_x;
              msg.base_y;
              msg.base_z;
              msg.base_roll;
              msg.base_pitch;
              msg.base_yaw;
              msg.NKY;
              msg.HNP;
              msg.HNR;
              msg.LSP;
              msg.LSR;
              msg.LSY;
              msg.LEB;
              msg.LWY;
              msg.LWP;
              msg.leftThumbKnuckle1;
              msg.leftThumbKnuckle2;
              msg.leftThumbKnuckle3;
              msg.leftPinkyKnuckle1;
              msg.leftPinkyKnuckle2;
              msg.leftPinkyKnuckle3;
              msg.leftRingKnuckle1;
              msg.leftRingKnuckle2;
              msg.leftRingKnuckle3;
              msg.leftMiddleKnuckle1;
              msg.leftMiddleKnuckle2;
              msg.leftMiddleKnuckle3;
              msg.leftIndexKnuckle1;
              msg.leftIndexKnuckle2;
              msg.leftIndexKnuckle3;
              msg.RSP;
              msg.RSR;
              msg.RSY;
              msg.REB;
              msg.RWY;
              msg.RWP;
              msg.rightThumbKnuckle1;
              msg.rightThumbKnuckle2;
              msg.rightThumbKnuckle3;
              msg.rightPinkyKnuckle1;
              msg.rightPinkyKnuckle2;
              msg.rightPinkyKnuckle3;
              msg.rightRingKnuckle1;
              msg.rightRingKnuckle2;
              msg.rightRingKnuckle3;
              msg.rightMiddleKnuckle1;
              msg.rightMiddleKnuckle2;
              msg.rightMiddleKnuckle3;
              msg.rightIndexKnuckle1;
              msg.rightIndexKnuckle2;
              msg.rightIndexKnuckle3;
              msg.WST;
              msg.LHY;
              msg.LHR;
              msg.LHP;
              msg.LKN;
              msg.LAP;
              msg.LAR;
              msg.RHY;
              msg.RHR;
              msg.RHP;
              msg.RKN;
              msg.RAP;
              msg.RAR;
              msg.base_xdot;
              msg.base_ydot;
              msg.base_zdot;
              msg.base_rolldot;
              msg.base_pitchdot;
              msg.base_yawdot;
              msg.NKYdot;
              msg.HNPdot;
              msg.HNRdot;
              msg.LSPdot;
              msg.LSRdot;
              msg.LSYdot;
              msg.LEBdot;
              msg.LWYdot;
              msg.LWPdot;
              msg.leftThumbKnuckle1dot;
              msg.leftThumbKnuckle2dot;
              msg.leftThumbKnuckle3dot;
              msg.leftPinkyKnuckle1dot;
              msg.leftPinkyKnuckle2dot;
              msg.leftPinkyKnuckle3dot;
              msg.leftRingKnuckle1dot;
              msg.leftRingKnuckle2dot;
              msg.leftRingKnuckle3dot;
              msg.leftMiddleKnuckle1dot;
              msg.leftMiddleKnuckle2dot;
              msg.leftMiddleKnuckle3dot;
              msg.leftIndexKnuckle1dot;
              msg.leftIndexKnuckle2dot;
              msg.leftIndexKnuckle3dot;
              msg.RSPdot;
              msg.RSRdot;
              msg.RSYdot;
              msg.REBdot;
              msg.RWYdot;
              msg.RWPdot;
              msg.rightThumbKnuckle1dot;
              msg.rightThumbKnuckle2dot;
              msg.rightThumbKnuckle3dot;
              msg.rightPinkyKnuckle1dot;
              msg.rightPinkyKnuckle2dot;
              msg.rightPinkyKnuckle3dot;
              msg.rightRingKnuckle1dot;
              msg.rightRingKnuckle2dot;
              msg.rightRingKnuckle3dot;
              msg.rightMiddleKnuckle1dot;
              msg.rightMiddleKnuckle2dot;
              msg.rightMiddleKnuckle3dot;
              msg.rightIndexKnuckle1dot;
              msg.rightIndexKnuckle2dot;
              msg.rightIndexKnuckle3dot;
              msg.WSTdot;
              msg.LHYdot;
              msg.LHRdot;
              msg.LHPdot;
              msg.LKNdot;
              msg.LAPdot;
              msg.LARdot;
              msg.RHYdot;
              msg.RHRdot;
              msg.RHPdot;
              msg.RKNdot;
              msg.RAPdot;
              msg.RARdot];
                
              disp([ 'LSP(POS):    ' sprintf('%f ', msg.LSP) ])
              disp([ 'LSP(VEL): ' sprintf('%f ', msg.LSPdot) ])
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
