class_name HUD extends CanvasLayer


@onready var battery: ProgressBar = %Battery
@onready var battery_time_left: Label = %BatteryTimeLeft
@onready var win_screen: Control = $WinScreen
@onready var dynamite_amount: Label = %DynamiteAmount
@onready var flare_amount: Label = %FlareAmount
@onready var worker_amount: Label = %WorkerAmount


var _total_workers := 0


func _ready() -> void:
	EventBus.on_battery_used.connect(_on_battery_used)
	EventBus.on_battery_charged.connect(_on_battery_charged)
	
	EventBus.on_bomb_bought.connect(_on_bomb_bought)
	EventBus.on_bomb_used.connect(_on_bomb_used)
	EventBus.on_bomb_refill.connect(_on_bomb_refill)
	
	EventBus.on_flare_bought.connect(_on_flare_bought)
	EventBus.on_flare_used.connect(_on_flare_used)
	EventBus.on_flare_refill.connect(_on_flare_refill)
	
	EventBus.on_rescue.connect(_on_rescue)
	
	
func _on_bomb_bought(current:int, max:int) -> void:
	dynamite_amount.text = str(current)
	
	
func _on_bomb_used(current:int, max:int) -> void:
	dynamite_amount.text = str(current)
	

func _on_bomb_refill(current:int, max:int) -> void:
	dynamite_amount.text = str(current)
	

func _on_flare_bought(current:int, max:int) -> void:
	flare_amount.text = str(current)
	
	
func _on_flare_used(current:int, max:int) -> void:
	flare_amount.text = str(current)
	

func _on_flare_refill(current:int, max:int) -> void:
	flare_amount.text = str(current)
	

func _on_battery_used(current:float, max:float) -> void:
	battery.max_value = max
	battery.value = current
	battery_time_left.text = "%ds" % battery.value


func _on_battery_charged(current:float, max:float) -> void:
	battery.max_value = max
	battery.value = current
	battery_time_left.text = "%ds" % battery.value


func _on_rescue() -> void:
	_total_workers += 1
	worker_amount.text = "%d" % _total_workers


func show_win_sceen() -> void:
	win_screen.visible = true
