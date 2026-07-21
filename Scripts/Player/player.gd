extends Node


signal health_change(data: Dictionary)
signal cash_change(data: Dictionary)

@export var lives: int = 20
@export var starter_cash: int
var cash: int


func _ready() -> void:
	cash = starter_cash
	cash_change.emit({ "cash": self.cash })


func _on_enemy_exit(data: Dictionary) -> void:
	lives -= data.get("lives")
	health_change.emit({ "lives": lives })


func _on_enemy_death(data: Dictionary) -> void:
	cash += data.get("cash")
	cash_change.emit({ "cash": cash })


func _on_tower_placed(data: Dictionary) -> void:
	var tower_cost = data.get("price")
	cash -= tower_cost
	cash_change.emit({ "cash": self.cash })
