function drawHubo

r = RigidBodyManipulator('urdf/hubo_minimal_contact.urdf');

v = r.constructVisualizer();
v.inspector();