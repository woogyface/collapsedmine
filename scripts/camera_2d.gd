extends Camera2D


@export var follow_object:Node2D


func _process(_delta: float) -> void:
	if follow_object:
		global_position = follow_object.global_position
