extends Node3D

signal enemy_exit(data)

func _ready() -> void:
	child_entered_tree.connect(_on_enemy_spawned)

func _on_enemy_spawned(node: Node) -> void:
	var enemy: Enemy = node.get_child(0)
	if enemy.has_signal("reached_end"):
		enemy.reached_end.connect(_on_enemy_exit)

func _on_enemy_exit(data: Dictionary) -> void:
	enemy_exit.emit(data)
