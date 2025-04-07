class_name Track extends AnimatedSprite2D

@onready var physics_wheel_1: RigidBody2D = %PhysicsWheel1
@onready var physics_wheel_2: RigidBody2D = %PhysicsWheel2

@onready var pin_joint_2d_1: PinJoint2D = %PinJoint2D1
@onready var pin_joint_2d_2: PinJoint2D = %PinJoint2D2


func attach_object(body:RigidBody2D) -> void:
	pin_joint_2d_1.node_a = pin_joint_2d_1.get_path_to(body)
	pin_joint_2d_2.node_a = pin_joint_2d_1.get_path_to(body)


func power(torque:float, delta:float) -> void:
	var total_power := torque * delta
	physics_wheel_1.angular_velocity = total_power
	physics_wheel_2.angular_velocity = total_power
	

func animate(anim:String) -> void:
	play(anim)
