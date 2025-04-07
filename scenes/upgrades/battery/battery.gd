class_name Battery extends Node

@export var default_charge:float
@export var consumtion_rate:float

@onready var _max_charge:float = default_charge
@onready var _current_charge:float = _max_charge


func _ready() -> void:
	EventBus.on_buy_battery.connect(_on_buy_battery)


func _on_buy_battery(amount:float) -> void:
	_max_charge += amount
	charge(_max_charge)
	
	
func reset() -> void:
	_max_charge = default_charge
	charge_full()
	

func use(amount:float) -> void:
	_current_charge -= amount
	EventBus.on_battery_used.emit(_current_charge, _max_charge)
	if _current_charge <= 0:
		EventBus.on_battery_depleted.emit()


func charge(amount:float) -> void:
	_current_charge += amount
	if _current_charge > _max_charge:
		_current_charge = _max_charge
	EventBus.on_battery_charged.emit(_current_charge, _max_charge)


func charge_full() -> void:
	_current_charge = _max_charge
	EventBus.on_battery_charged.emit(_current_charge, _max_charge)
