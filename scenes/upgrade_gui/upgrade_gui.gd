extends SubViewport


var points_per_rescue:int = 2
var total_points:int = 0


@onready var info: Label = %Info
@onready var upgrade_points:int = total_points


func _ready() -> void:
	EventBus.on_rescue.connect(_on_rescue)
	_update_gui()


func _update_gui() -> void:
	if upgrade_points <= 0:
		info.text = "You can't buy upgrades now."
	if upgrade_points > 0:
		info.text = "Press 1-3 to buy %d upgrade." % upgrade_points
	if upgrade_points > 1:
		info.text = "Press 1-3 to buy %d upgrades." % upgrade_points


func reset() -> void:
	upgrade_points = total_points
	_update_gui()


func _on_rescue() -> void:
	total_points += points_per_rescue
	upgrade_points += points_per_rescue
	_update_gui()
	

func buy_battery(amount:float) -> void:
	EventBus.on_buy_battery.emit(amount)
	upgrade_points -= 1
	_update_gui()
	
	
func buy_bomb(amount:int) -> void:
	EventBus.on_buy_bomb.emit(amount)
	upgrade_points -= 1
	_update_gui()
	
	
func buy_flare(amount:int) -> void:
	EventBus.on_buy_flare.emit(amount)
	upgrade_points -= 1
	_update_gui()
	
