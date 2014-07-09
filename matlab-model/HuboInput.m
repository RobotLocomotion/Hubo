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
          defaultChan = 'HuboInput';
        end
        function publish(obj,t,x,channel)
            
            msg = hubo.hubo_hubo2input();
            msg.timestamp = t;
            %State Conversion
            msg.NeckYaw = x(7);
            msg.Neck1 = x(8);
            msg.Neck2 = x(9);
            msg.LeftShoulderPitch = x(10);
            msg.LeftShoulderRoll = x(11);
            msg.LeftShoulderYaw = x(12);
            msg.LeftElbowPitch = x(13);
            msg.LeftWristYaw = x(14);
            msg.LeftWristPitch = x(15);
            msg.RightShoulderPitch = x(16);
            msg.RightShoulderRoll = x(17);
            msg.RightShoulderYaw = x(18);
            msg.RightElbowPitch = x(19);
            msg.RightWristYaw = x(20);
            msg.RightWristPitch = x(21);
            msg.TrunkYaw = x(22);
            msg.LeftHipYaw = x(23);
            msg.LeftHipRoll = x(24);
            msg.LeftHipPitch = x(25);
            msg.LeftKneePitch = x(26);
            msg.LeftAnklePitch = x(27);
            msg.LeftAnkleRoll = x(28);
            msg.RightHipYaw = x(29);
            msg.RightHipRoll = x(30);
            msg.RightHipPitch = x(31);
            msg.RightKneePitch = x(32);
            msg.RightAnklePitch = x(33);
            msg.RightAnkleRoll = x(34);
            msg.NeckYawdot = x(41);
            msg.Neck1dot = x(42);
            msg.Neck2dot = x(4);
            msg.LeftShoulderPitchdot = x(44);
            msg.LeftShoulderRolldot = x(45);
            msg.LeftShoulderYawdot = x(46);
            msg.LeftElbowPitchdot = x(47);
            msg.LeftWristYawdot = x(48);
            msg.LeftWristPitchdot = x(49);
            msg.RightShoulderPitchdot = x(50);
            msg.RightShoulderRolldot = x(51);
            msg.RightShoulderYawdot = x(52);
            msg.RightElbowPitchdot = x(53);
            msg.RightWristYawdot = x(54);
            msg.RightWristPitchdot = x(55);
            msg.TrunkYawdot = x(56);
            msg.LeftHipYawdot = x(57);
            msg.LeftHipRolldot = x(58);
            msg.LeftHipPitchdot = x(59);
            msg.LeftKneePitchdot = x(60);
            msg.LeftAnklePitchdot = x(61);
            msg.LeftAnkleRolldot = x(62);
            msg.RightHipYawdot = x(63);
            msg.RightHipRolldot = x(64);
            msg.RightHipPitchdot = x(65);
            msg.RightKneePitchdot = x(66);
            msg.RightAnklePitchdot = x(67);
            msg.RightAnkleRolldot = x(68);
            lcm.lcm.LCM('udpm://239.255.76.67:7667?ttl=1').publish('HuboRef', msg);
        
        end
    end
    
end
