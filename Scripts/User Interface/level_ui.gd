extends Control


@onready var wave_label = $MarginContainer/Container/Wave
@onready var lives_label = $MarginContainer/Container/Lives
@onready var fps_label = $MarginContainer/FPS


func setup(starter_health: int, total_waves: int) -> void:
	lives_label.text = "Lives: " + str(starter_health)
	wave_label.text = "Wave 1/" + str(total_waves)


func _process(_delta: float) -> void:
	fps_label.text = "fps " + str(Engine.get_frames_per_second())


func _on_health_change(data: Dictionary) -> void:
	lives_label.text = "Lives: " + str(data.get("lives"))


func _on_wave_change(data: Dictionary) -> void:
	wave_label.text = "Wave " + str(data.get("new_wave")) + "/" + str(data.get("total_waves"))
