class_name Launcher extends Node

var _dynamite_max_amount:int = 0
var _dynamite_current_amount:int = 0
var _flare_max_amount:int = 0
var _flare_current_amount:int = 0

const DYNAMITE := preload("res://scenes/dynamite/dynamite.tscn")
const FLARE := preload("res://scenes/flare/flare.tscn")


func _ready() -> void:
	EventBus.on_buy_bomb.connect(_on_buy_bomb)
	EventBus.on_buy_flare.connect(_on_buy_flare)
	
	
func _on_buy_bomb(amount:int) -> void:
	_dynamite_max_amount += amount
	_dynamite_current_amount = _dynamite_max_amount
	EventBus.on_bomb_bought.emit(_dynamite_current_amount, _dynamite_max_amount)
	
	
func _on_buy_flare(amount:int) -> void:
	_flare_max_amount += amount
	_flare_current_amount = _flare_max_amount
	EventBus.on_flare_bought.emit(_flare_current_amount, _flare_max_amount)
	

func reset() -> void:
	_dynamite_max_amount = 0
	_flare_max_amount = 0
	refill_dynamite_max()
	refill_flare_max()

	
func use_dynamite(position:Vector2, direction:Vector2) -> void:
	if _dynamite_current_amount >= 1:
		_dynamite_current_amount -= 1
		_throw_dynamite(position, direction)
		EventBus.on_bomb_used.emit(_dynamite_current_amount, _dynamite_max_amount)
		
		
func use_flare(position:Vector2, direction:Vector2) -> void:
	if _flare_current_amount >= 1:
		_flare_current_amount -= 1
		_throw_flare(position, direction)
		EventBus.on_flare_used.emit(_flare_current_amount, _flare_max_amount)
			
			
func refill_dynamite(amount:int) -> void:
	_dynamite_current_amount += amount
	if _dynamite_current_amount > _dynamite_max_amount:
		_dynamite_current_amount = _dynamite_max_amount
	EventBus.on_bomb_refill.emit(_dynamite_current_amount, _dynamite_max_amount)
	
	
func refill_dynamite_max() -> void:
	_dynamite_current_amount = _dynamite_max_amount
	EventBus.on_bomb_refill.emit(_dynamite_current_amount, _dynamite_max_amount)


func refill_flare(amount:int) -> void:
	_flare_current_amount += amount
	if _flare_current_amount > _flare_max_amount:
		_flare_current_amount = _flare_max_amount
	EventBus.on_flare_refill.emit(_flare_current_amount, _flare_max_amount)
	
	
func refill_flare_max() -> void:
	_flare_current_amount = _flare_max_amount
	EventBus.on_flare_refill.emit(_flare_current_amount, _flare_max_amount)
	

func _throw_dynamite(position:Vector2, direction:Vector2) -> void:
	var dynamite := DYNAMITE.instantiate() as RigidBody2D
	dynamite.global_position = position
	var torque := 10 * direction.x
	dynamite.angular_velocity = torque
	dynamite.apply_impulse(direction * 1000)
	add_child(dynamite)


func _throw_flare(position:Vector2, direction:Vector2) -> void:
	var flare := FLARE.instantiate() as RigidBody2D
	flare.global_position = position
	var torque := 10 * direction.x
	flare.angular_velocity = torque
	flare.apply_impulse(direction * 1000)
	add_child(flare)
