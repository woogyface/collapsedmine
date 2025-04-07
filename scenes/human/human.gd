class_name Human extends Node2D

@onready var rescue_area: Area2D = %RescueArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var _is_rescued:bool = false


func _ready() -> void:
	rescue_area.body_entered.connect(_on_body_entered)
	animation_player.play("idle")
	EventBus.pre_respawn.connect(_on_pre_respawn)
	

func _on_body_entered(body:Node2D) -> void:
	if body is Player and not _is_rescued:
		print("Yay, you rescued a thing!")
		animation_player.play("happy")
		_is_rescued = true
		EventBus.on_rescue.emit()


func _on_pre_respawn() -> void:
	if _is_rescued:
		queue_free()
