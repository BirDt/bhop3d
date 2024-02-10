# BHop 3D
BHop 3D is a source-like (Team Fortress 2, Counter Strike, Apex Legends, etc) movement controller for Godot.

Completely usable in it's current state, though basic. If I ever come back to this, this is what I'd like to add:
- Crouching, and sliding a la Apex
- Wall running a la Titanfall
- Tap strafing a la Titanfall/Apex
- Blast jumping and knockback functions a la Team Fortress 2

No guarantees are made as to the chances of any of those being implemented. Feel free to PR.

Most of the basic movement code is lifted and adjusted from [this article by Flafla2](https://adrianb.io/2015/02/14/bunnyhop.html). Go give it a read!

## Usage
Create a new BHop3D node:

![image](https://github.com/BirDt/bhop3d/assets/24282498/0d6eed97-f3ed-4de8-93bc-344e776db2bf)


The BHop3D node extends Godot's CharacterBody3D. It therefore needs a CollisionShape3D. 
Additionally, BHop3D provides mouse input/look logic, so create a child Camera3D as well.

![image](https://github.com/BirDt/bhop3d/assets/24282498/aae253e4-9ad0-4dd6-a53e-ad0ac7837ddb)

To use the built-in camera look logic, set the Camera property under the Controlled Nodes category here:

![image](https://github.com/BirDt/bhop3d/assets/24282498/836f57fd-b4fa-42b7-8b71-5fb6e7c51a14)

All code is commented to explain the export values, but for reference:
- **Activity Controls**
  - **look_enabled**: whether the player should be able to look around.
  - **move_enabled**: whether the player should be able to move. NOTE: this does not freeze the player, only stop their ability to input new directions.
- **Input Definitions**
  - **sensitivity**: A multiplier for mouse input sensitivity. Allows setting the sensitivity on the X and Y axis independently.
  - **move_forward/backward/left/right**: Action names (strings) for the basic movement inputs.
  - **jump**: Action name (string) for the jump input.
- **Movement Variables**
  - **gravity**: Self explanatory.
  - **ground_accelerate**: How quickly to accelerate while on the ground.
  - **air_accelerate**: How quickly to accelerate while in the air. Higher values mean more speed gained from air-strafing.
  - **max_ground_velocity**: Maximum velocity on the ground. Not a hard cap; speed tends towards this value while grounded.
  - **max_air_velocity**: As above but in the air.
  - **jump_force**: Self explanatory.
  - **friction**: Self explanatory.
  - **bhop_frames**: How many frames a player can be grounded for while a bunnyhop can still be performed.
  - **additive_bhop**: When enabled, player velocity converges to input direction. When disabled, velocity maintains a semi-constant offset from input direction (similar to some Source games, such as Counter Strike 2).
- **Debug**
  - **debug_mode_enabled**: Whether any assigned debug raycasts be updated each frame.
  - **debug_wishdir_raycast**: The raycast to update to display the desired input direction.
  - **debug_velocity_raycast**: The raycast to update to display the current velocity (sans the Y component).

**A note about debug mode**: Very primitive, best used when only looking in a straight line.
