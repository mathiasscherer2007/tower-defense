extends Node3D


signal enemy_exit(data)
signal enemy_death(data)

## Enemy speed multiplier
@export var speed_scale: float = 1


func _ready() -> void:
	child_entered_tree.connect(_on_enemy_spawned)


func _on_enemy_spawned(node: Node) -> void:
	var enemy: Enemy = node.get_child(0)
	enemy.speed *= speed_scale
	enemy.reached_end.connect(_on_enemy_exit)
	enemy.died.connect(_on_enemy_death)


func _on_enemy_exit(data: Dictionary) -> void:
	enemy_exit.emit(data)


func _on_enemy_death(data: Dictionary) -> void:
	enemy_death.emit(data)
