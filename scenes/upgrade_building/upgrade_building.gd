class_name UpgradeBuilding extends Node2D


@onready var area_2d: Area2D = $Area2D
@onready var upgrade_gui_texture: TextureRect = $UpgradeGUITexture
@onready var upgrade_gui: SubViewport = $UpgradeGUI


var _is_inside_shop:bool = false
var _player:Player = null


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	
	
func _process(delta: float) -> void:
	if _is_inside_shop and upgrade_gui.upgrade_points > 0:
		if Input.is_action_just_pressed("buy_battery"):
			upgrade_gui.buy_battery(10)
		elif Input.is_action_just_pressed("buy_bombs"):
			upgrade_gui.buy_bomb(2)
		elif Input.is_action_just_pressed("buy_flares"):
			upgrade_gui.buy_flare(5)
		elif Input.is_action_just_pressed("reset_points"):
			upgrade_gui.reset()
			_player.battery.reset()
			_player.launcher.reset()
			
			
	if _is_inside_shop and _player != null:
		_player.battery.charge_full()
			
	
func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		print("You are in the shop")
		upgrade_gui_texture.visible = true
		_is_inside_shop = true
		_player = body as Player


func _on_body_exited(body:Node2D) -> void:
	if body is Player:
		print("You left the shop")
		upgrade_gui_texture.visible = false
		_is_inside_shop = false
		_player = null
