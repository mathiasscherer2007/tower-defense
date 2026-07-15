extends Node3D

signal health_change(new_health: int)

@export var lives: int = 20
@export var cash: int = 100


func _on_enemy_exit(data: Dictionary) -> void:
	lives -= data.lives
	health_change.emit(lives)
