extends Camera3D


var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()


func _on_enemy_exit(data) -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, 0.5 * data.get("lives"), 0.0, 0.2)


func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity * Globals.screen_shake_mult
	self.h_offset = camera_offset/5
	self.v_offset = camera_offset/7
