classdef HuboReductionTransform < CoordinateTransform

  methods
    function obj=HuboReductionTransform(from,to,feedthroughflag,tiflag)
      typecheck(from, 'HuboState');
      typecheck(to, 'HuboInput');
      obj = obj@CoordinateTransform(from,to,feedthroughflag,tiflag)
      obj=setInputFrame(obj,from);
      obj=setOutputFrame(obj,to);
    end

    function ytraj = trajectoryOutput(obj,xtraj,utraj)%Reduction
    
       ytraj = xtraj();
    end
    function y = output(obj,t,x,u)
       if isempty(u)
           y = zeros(28,1);
           return
       end
       y = u(7:35);
    end
  end
end
