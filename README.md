Hubo
====

Humanoid robot from KAIST

This is a set of tools and setup for Hubo-drake integration.


The current setup is that a desktop computer is interacting with the PC/104 computer onboard of Hubo.

The PC/104 uses ach-lcm-util to broadcast lcm channels on its state and control.  And the desktop computer uses matlab-model to interact with the broadcasted lcm channels.  Though there are a few tools in ach-lcm-util that is useful to use on the desktop as well.


========= Features ========

URDF.............OK
runPassive.......OK
Live Visualier...OK
Live Inspector...WIP


================== URDF

There are three different URDF.
1. hubo.urdf  Basic urdf with hubo.  The body parts are linked from the robot's torso and build outwards.  This is the base version for all Hubo's URDF.
2. hubo-shifted.urdf  Because of the ground collision detection in drake.  The model shouldn't begin within the ground.  This URDF is shifted manually.
3. hubo-wBaseLink.urdf  To allow the model to be easily manipulated and moved during simulation setup or any other conditions.  The baselink represents where the robot is standing, but this assumption isn't absolute nor enforced.

=================== runPassive

Here the robot will be simulated by drake.  The result is that the robot collapsed to the ground, because none of the motor is powered.  A few things to note during this test.
1. The robot can collapse onto itself.  The collision meshs should not be on at this point, thus it is okay for Hubo's body part to collide with each other.
2. The ground is the only mesh that the simulated Hubo body will react with.  Make sure that Hubo doesn't penatrate the ground.


================== Live Visualizer

To run the live visualizer, you'll have to active send-message-ach-matlab and hubo-ach on Hubo.  By doing so, you'll turn Hubo into an LCM node.  Then Matlab can be turned on and interact with Hubo.  If you run HuboPlant.track() on matlab, the Live VIsualizer will start up.


