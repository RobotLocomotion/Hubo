classdef HuboVisualizer < Visualizer
        % HuboVisualizer visualizer class to command and playback
        % trajectory on Hubo.
        methods
            function obj = HuboVisualizer(input_frame,state_frame)
                %  @param input_frame Robot's InputFrame
                %  @param state_frame Robot's StateFrame
                % 
                
                %TODO
            end
            
            function playbackcommand(obj,xtraj,options)
                %  This function is based off of Visualizer's playback
                %  function.  This animates a given trajectory in quasi-
                %  correct time to an LCM robot.  At the sametime, the
                %  robot's output will be tracked on the graphical
                %  visualizer.
                %  @param xtraj trajectory to command the robot
                %  @param options visualizer configuration:
                %                         N/A
                typecheck(xtraj,'Trajectory');
                if (xtraj.getOutputFrame()~=obj.getInputFrame)
                    %Try to convert the frame.
                    %This will most likely happen.  Make sure 
                    %you define the robot's CoordinateTransformations.
                    xtraj = xtraj.inFrame(obj.getInputFrame);
                end
                
                if nargin < 3
                    options = struct();
                end
                tspan = xtraj.getBreaks();
                %Begin a timer event to command the robot periodically.
                
                ti = timer('TimerFcn',{@timer_command},'ExecutionMode','fixedRate',...
                        'Period',max(obj.display_dt/obj.playback_speed,.01),...
                        'TasksToExecute',time_steps,'BusyMode','queue');
                start(ti);
                wait(ti);  % unfortunately, you can't try/catch a ctrl-c in matlab
                delete(ti);
                function timer_command(timerobj,event)
                    t=t0+obj.playback_speed*toc;
                    if (t>tspan(end))
                        stop(timerobj);
                        return;
                    end
                    if (ts(1)>0) t = round((t-ts(2))/ts(1))*ts(1) + ts(2); end  % align with sample times if necessary
                    x = xtraj.eval(t);
                    set(time_slider, 'Value', t)
                    update_time_display(time_slider, [])
                    if ~get(play_button, 'UserData')
                        stop(timerobj);
                        return;
                    end
                end
                
                
            end
            
        end
end
