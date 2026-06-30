class_name Tower extends Node3D

var enemies: Array

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area not in enemies:
		enemies.append(area)

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area in enemies:
		enemies.erase(area)
