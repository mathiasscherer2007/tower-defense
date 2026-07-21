class_name TowerHandler extends Node3D


signal tower_placed(data: Dictionary)


func _ready() -> void:
	for child in get_children():
		if child is Tower:
			child.activate()


func _on_tower_placed(data: Dictionary) -> void:
	var tower = data.get("scene").instantiate()
	var pos: Vector3 = data.get("position")
	
	tower.mode = Enums.tower_modes.TOWER
	add_child(tower)
	tower.global_position = pos
	tower.global_rotation = data.get("rotation")
	tower_placed.emit({
		"tower": tower
	})
