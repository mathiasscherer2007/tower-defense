extends Tower

func _process(_delta: float) -> void:
	if enemies.size() > 0:
		var enemy_pos: Vector3 = enemies[0].global_position
		var current_pos: Vector3 = $geometry.global_position
		$geometry.look_at(Vector3(enemy_pos.x, current_pos.y, enemy_pos.z))
