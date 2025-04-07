class_name Player extends RigidBody2D

@export var respawn_point:Node2D
@export var max_speed:float

@onready var robot_body: Sprite2D = %RobotBody
@onready var track_right: Track = %TrackRight
@onready var track_left: Track = %TrackLeft
@onready var battery: Battery = %Battery
@onready var launcher: Launcher = %Launcher
@onready var throw_position: Marker2D = $ThrowPosition
@onready var flashlight: PointLight2D = %Flashlight
@onready var lights: Node2D = $Lights

var allow_respawn:bool = true


func _ready() -> void:
	track_left.attach_object(self)
	track_right.attach_object(self)
	battery.charge_full()
	launcher.refill_dynamite_max()
	launcher.refill_flare_max()
	EventBus.on_battery_depleted.connect(_on_battery_depleted)


func _physics_process(delta: float) -> void:
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	if right:
		_look_right()
		_animate_tracks("drive")
		_power_wheels(max_speed, delta)
		battery.use(1.0 * delta)
	if left:
		_look_left()
		_animate_tracks("drive")
		_power_wheels(-max_speed, delta)
		battery.use(1.0 * delta)
		
	if not right and not left:
		_animate_tracks("idle")
		
	if Input.is_action_just_pressed("throw_dynamite"):
		launcher.use_dynamite(throw_position.global_position, throw_position.transform.y)
	if Input.is_action_just_pressed("throw_flare"):
		launcher.use_flare(throw_position.global_position, throw_position.transform.y)
	if Input.is_action_pressed("respawn"):
		battery.use(5.0 * delta)


func _on_battery_depleted() -> void:
	EventBus.pre_respawn.emit()
	await Engine.get_main_loop().process_frame
	EventBus.respawn.emit()

		
func _look_right() -> void:
	robot_body.flip_h = false
	track_right.z_index = 0
	track_right.flip_h = false
	track_left.z_index = -1
	track_left.flip_h = false
	throw_position.global_rotation = deg_to_rad(-105)
	flashlight.position = Vector2(30.0, -97.0)
	flashlight.rotation = 0
	

func _look_left() -> void:
	robot_body.flip_h = true
	track_right.z_index = -1
	track_right.flip_h = true
	track_left.z_index = 0
	track_left.flip_h = true
	throw_position.global_rotation = deg_to_rad(-255)
	flashlight.position = Vector2(-29.0, -97.0)
	flashlight.rotation = PI

		
func _animate_tracks(animation:String) -> void:
	track_right.animate(animation)
	track_left.animate(animation)
	
	
func _power_wheels(torque:float, delta:float) -> void:
	track_right.power(torque, delta)
	track_left.power(torque, delta)


func respawn() -> void:
	if allow_respawn:
		visible = false
		await Engine.get_main_loop().process_frame
		global_position = respawn_point.global_position
		linear_velocity = Vector2.ZERO
		await Engine.get_main_loop().process_frame
		visible = true
		rotation = 0
		battery.charge_full()
		launcher.refill_dynamite_max()
		launcher.refill_flare_max()
		disable_lights()


func enable_lights() -> void:
	lights.visible = true
	
	
func disable_lights() -> void:
	lights.visible = false
