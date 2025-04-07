class_name Wheel extends RayCast2D


@export var radius:float = 1.0
@export var suspension_rest_dist:float = 25.0
@export var spring_strength:float = 10.0
@export var spring_length:float = 50.0
@export var spring_damper:float = 100.0

@onready var marker_2d: Marker2D = $Marker2D


var _prev_spring_length:float
var _col:Vector2


func _draw() -> void:
	if is_colliding():
		draw_circle(marker_2d.position, 10, Color.BLUE, false)
	else:
		draw_circle(marker_2d.position, 10, Color.RED, false)


func _physics_process(delta: float) -> void:
	if is_colliding():
		var collision_point := get_collision_point()
		marker_2d.position = to_local(collision_point)
		var collision_normal := get_collision_normal()
		for child in get_children():
			if child is RigidBody2D:
				_handle_suspension(child, delta, collision_point)
		#_handle_acceleration(collision_point, collision_normal)
		#_handle_friction(delta, collision_point)
		
		
func _handle_suspension(body:RigidBody2D, delta:float, collision_point:Vector2) -> void:
		var wheel_up := to_global(target_position.normalized())
		var suspension_dir := wheel_up
		var dist := collision_point.distance_to(global_position)
		
		var spring_length:float = clamp(dist - radius, 0, suspension_rest_dist)
		var spring_force := spring_strength * (suspension_rest_dist - spring_length)
		var spring_vel := (_prev_spring_length - spring_length) / delta
		var damper_force := spring_damper * spring_vel
		
		var suspension_force := wheel_up * (spring_force + damper_force)
		_prev_spring_length = spring_length
		
		var result_force := suspension_dir * suspension_force
		print(result_force)
		body.apply_force(result_force, collision_point - body.global_position)
		
		#if debug:
		#	DebugDraw3D.draw_arrow(global_position, to_global(position + Vector3(-position.x, (suspension_force.y/2)*0.001, -position.z)), Color.YELLOW, 0.1)
		#	DebugDraw3D.draw_line_hit_offset(global_position, to_global(position + Vector3(-position.x, -1, -position.z)), true, dist, 0.2, Color.RED, Color.PINK)
			
			
#func _handle_acceleration(collision_point:Vector2, collision_normal:Vector2) -> void:
	#var accel_dir := -global_basis.z
	#var torque := _accel * car.engine.power
	#var point = collision_point + Vector3(0,radius,0)
	#var cross_right := -global_basis.z.cross(collision_normal)
	#var cross_forward := -global_basis.x.cross(collision_normal)
	#var slip_right := (collision_normal-Vector3.UP).dot(cross_right) * cross_right * slipyness
	#var slip_forward := (collision_normal-Vector3.UP).dot(cross_forward) * cross_forward * slipyness
	#
	#car.apply_force(accel_dir * torque + slip_right + slip_forward, point - car.global_position)
	#
	#if debug:
		#DebugDraw3D.draw_arrow(point, point + (accel_dir * torque)*0.001, Color.BLUE, 0.1, true)
		#DebugDraw3D.draw_arrow(global_position+Vector3(0,1,0), Vector3(0,1,0)+ global_position + collision_normal, Color.GREEN, 0.1, true)
		#DebugDraw3D.draw_arrow(global_position+Vector3(0,1,0), Vector3(0,1,0)+ global_position + cross_right, Color.RED*0.5, 0.1, true)
		#DebugDraw3D.draw_arrow(global_position+Vector3(0,1,0), Vector3(0,1,0)+ global_position + slip_right*0.001, Color.RED, 0.1, true)
		#DebugDraw3D.draw_arrow(global_position+Vector3(0,1,0), Vector3(0,1,0)+ global_position + cross_forward, Color.BLUE*0.5, 0.1, true)
		#DebugDraw3D.draw_arrow(global_position+Vector3(0,1,0), Vector3(0,1,0)+ global_position + slip_forward*0.001, Color.BLUE, 0.1, true)
		


#func _handle_friction(delta:float, collision_point:Vector2) -> void:
	#var dir_z := global_basis.z
	#var dir_x := global_basis.x
	#var tire_world_vel := _get_point_velocity(global_position)
	#var z_force = (dir_z.dot(tire_world_vel) * forward_friction * car.car_config.air_resistance) / delta
	#var x_force = (dir_x.dot(tire_world_vel) * sideways_friction * car.car_config.air_resistance) / delta
	#car.apply_force(-dir_z * z_force + -dir_x * x_force, collision_point - car.global_position)
	#
	#var point = collision_point + Vector3(0,radius,0)
	#if debug:
		#DebugDraw3D.draw_arrow(point, point + (-dir_z * z_force)*0.001, Color.BLUE, 0.1, true)
		#DebugDraw3D.draw_arrow(point, point + (-dir_x * x_force)*0.001, Color.BLUE, 0.1, true)
