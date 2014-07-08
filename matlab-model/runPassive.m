function runPassive

options.ignore_self_collisions = true;
options.floating = true;
options.terrain = RigidBodyFlatTerrain();

w = warning('on','Drake:RigidBodyManipulator:UnsupportedContactPoints');
warning('on','Drake:RigidBodyManipulator:UnsupportedJointLimits');
warning('on','Drake:RigidBodyManipulator:BodyHasZeroInertia');
warning('on','Drake:RigidBodyManipulator:UnsupportedVelocityLimits');
warning('on','Drake:RigidBodyGeometry:SimplifiedCollisionGeometry');
r = TimeSteppingRigidBodyManipulator('urdf/hubo_minimal_contact.urdf',0.001,options);
warning(w);

r = setSimulinkParam(r,'MinStep','0.001');
x0 = Point(r.getStateFrame);
x0 = resolveConstraints(r,x0)

v = r.constructVisualizer;
v.display_dt = .05;

if (0)
  % Run animation while it is simulating (as fast as possible, but probably
  % slower than realtime)
  s = warning('off','Drake:DrakeSystem:UnsupportedSampleTime');  % we are knowingly breaking out to a simulink model with the cascade on the following line.
  warning(s);
  simulate(sys,[0 2],x0)
else 
% Run simulation, then play it back at realtime speed
  xtraj = simulate(r,[0 0.8],x0);
  options.slider=true;
  v.playback(xtraj,options);
end

