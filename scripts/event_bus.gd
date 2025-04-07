extends Node


signal on_battery_used(current_charge:float, max_charge:float)
signal on_battery_charged(current_charge:float, max_charge:float)
signal on_battery_depleted()
signal on_buy_battery(amount:float)

signal on_bomb_used(current:int, max:int)
signal on_bomb_refill(current:int, max:int)
signal on_buy_bomb(amount:int)
signal on_bomb_bought(current:int, max:int)

signal on_flare_used(current:int, max:int)
signal on_flare_refill(current:int, max:int)
signal on_buy_flare(amount:int)
signal on_flare_bought(current:int, max:int)

signal on_rescue()

signal pre_respawn()
signal respawn()
