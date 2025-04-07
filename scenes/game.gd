extends Node2D

@onready var player: Player = %Player
@onready var spawn_point: Node2D = %SpawnPoint
@onready var humans: Node = $Humans
@onready var hud: HUD = $HUD

func _ready() -> void:
	EventBus.respawn.connect(_on_respawn)
	_respawn_player()
	
func _on_respawn() -> void:
	_respawn_player()


func _respawn_player() -> void:
	player.respawn()
	if humans.get_child_count() == 0:
		hud.show_win_sceen()
