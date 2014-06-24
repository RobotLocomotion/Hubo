function testLCMPlant

checkDependency('lcm');

p = addpath([getDrakePath,'/examples/Hubo']);

lc = lcm.lcm.LCM.getSingleton();
aggregator = lcm.lcm.MessageAggregator();
lc.subscribe('EXAMPLE',aggregator);

r= HuboPlant()
r.constructVisualizer()
runLCM(r,[],struct('tspan',[0,inf]))

if (aggregator.numMessagesAvailable()<1)
  error('looks like i''m not receiving LCM dynamics messages');
end

path(p);
