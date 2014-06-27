classdef HuboPlant < TimeSteppingRigidBodyManipulator
    methods
        function obj=HuboPlant(urdf, time,options)
            if nargin < 1 || isempty(urdf)
                urdf = 'urdf/hubo_base_link.urdf';
            end
            if nargin < 2
                time = .0005;
            end
            if nargin < 3
                options = struct();
                options.floating = true;
            end
            obj = obj@TimeSteppingRigidBodyManipulator(urdf,time,options);
            %State
            state_frame = HuboState(obj);
            obj = obj.setStateFrame(state_frame);
            obj = obj.setOutputFrame(state_frame);
            %Input
            input_frame = HuboInput(obj);
            obj = obj.setInputFrame(input_frame);
            
            
            %kp = diag([repmat(150,1,18),repmat(200,1,9)]); % note: not tunes AT ALL yet
            %kd=diag([ones(18,1);5*ones(9,1)]);
            %pdcontrol(r,kp,kd,6+(1:27));
            %plant = setInputFrame(plant,HuboJointCommand());

            %v = r.constructVisualizer();
            %v.display_dt=0.05;


            %end

        end
        function x = track(obj)
            
            v = obj.constructVisualizer();
            while true
                [x,t] = obj.getOutputFrame().getNextMessage(1000);
                v.draw(t,x);
                obj.getInputFrame();
                pause(0.1);
            end
        end
        function x = remoteControl(obj)
            v = obj.constructVisualizer();
            i = v.inspector();
            
        end
    end
end

