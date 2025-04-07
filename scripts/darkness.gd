extends Node


@onready var level_light: CanvasModulate = $LevelLight
@onready var trigger: Area2D = $Trigger
@onready var inside: Area2D = $Inside
@onready var outside: Area2D = $Outside
@onready var player: Player = %Player


var _is_inside_trigger:bool = false


func _ready() -> void:
	EventBus.respawn.connect(_on_respawn)
	
	trigger.body_entered.connect(_on_trigger_entered)
	trigger.body_exited.connect(_on_trigger_exited)
	
	outside.body_entered.connect(_on_outside_entered)

	inside.body_entered.connect(_on_inside_entered)

func _process(delta: float) -> void:
	if _is_inside_trigger:
		var out_pos := outside.global_position
		var in_pos := inside.global_position
		var value := remap(player.global_position.x, out_pos.x, in_pos.x, 0.0, 1.0)
		level_light.color = lerp(Color.WHITE, Color.BLACK, value)
		
		if value > 0.5:
			player.enable_lights()
	

func _on_respawn() -> void:
	level_light.visible = false
	print(level_light.color)

	
func _on_trigger_entered(body:Node2D) -> void:
	_is_inside_trigger = true
	level_light.visible = true
	
	
func _on_trigger_exited(body:Node2D) -> void:
	_is_inside_trigger = false
	
	
func _on_outside_entered(body:Node2D) -> void:
	level_light.color = Color.WHITE
	player.disable_lights()
	
	
func _on_inside_entered(body:Node2D) -> void:
	level_light.color = Color.BLACK
