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
            
            msg = lcmtypes.lcmt_hubo2state();
            msg.timestamp = t;
            %State Conversion
            msg.base_x = x(1);
            msg.base_y = x(2);
            msg.base_z = x(3);
            msg.base_roll = x(4);
            msg.base_pitch = x(5);
            msg.base_yaw = x(6);
            msg.NKY = x(7);
            msg.HNP = x(8);
            msg.HNR = x(9);
            msg.LSP = x(10);
            msg.LSR = x(11);
            msg.LSY = x(12);
            msg.LEB = x(13);
            msg.LWY = x(14);
            msg.LWP = x(15);
            msg.leftThumbKnuckle1 = x(16);
            msg.leftThumbKnuckle2 = x(17);
            msg.leftThumbKnuckle3 = x(18);
            msg.leftPinkyKnuckle1 = x(19);
            msg.leftPinkyKnuckle2 = x(20);
            msg.leftPinkyKnuckle3 = x(21);
            msg.leftRingKnuckle1 = x(22);
            msg.leftRingKnuckle2 = x(23);
            msg.leftRingKnuckle3 = x(24);
            msg.leftMiddleKnuckle1 = x(25);
            msg.leftMiddleKnuckle2 = x(26);
            msg.leftMiddleKnuckle3 = x(27);
            msg.leftIndexKnuckle1 = x(28);
            msg.leftIndexKnuckle2 = x(29);
            msg.leftIndexKnuckle3 = x(30);
            msg.RSP = x(31);
            msg.RSR = x(32);
            msg.RSY = x(33);
            msg.REB = x(34);
            msg.RWY = x(35);
            msg.RWP = x(36);
            msg.rightThumbKnuckle1 = x(37);
            msg.rightThumbKnuckle2 = x(38);
            msg.rightThumbKnuckle3 = x(39);
            msg.rightPinkyKnuckle1 = x(40);
            msg.rightPinkyKnuckle2 = x(41);
            msg.rightPinkyKnuckle3 = x(42);
            msg.rightRingKnuckle1 = x(43);
            msg.rightRingKnuckle2 = x(44);
            msg.rightRingKnuckle3 = x(45);
            msg.rightMiddleKnuckle1 = x(46);
            msg.rightMiddleKnuckle2 = x(47);
            msg.rightMiddleKnuckle3 = x(48);
            msg.rightIndexKnuckle1 = x(49);
            msg.rightIndexKnuckle2 = x(50);
            msg.rightIndexKnuckle3 = x(51);
            msg.WST = x(52);
            msg.LHY = x(53);
            msg.LHR = x(54);
            msg.LHP = x(55);
            msg.LKN = x(56);
            msg.LAP = x(57);
            msg.LAR = x(58);
            msg.RHY = x(59);
            msg.RHR = x(60);
            msg.RHP = x(61);
            msg.RKN = x(62);
            msg.RAP = x(63);
            msg.RAR = x(64);

            lcm.lcm.LCM('udpm://239.255.76.67:7667?ttl=1').publish('HuboRef', msg);
        
        end
    end
    
end