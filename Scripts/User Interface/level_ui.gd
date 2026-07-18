extends Control


@onready var wave_label = $MarginContainer/Container/Wave
@onready var lives_label = $MarginContainer/Container/Lives
@onready var cash_label = $MarginContainer/Container/Cash
@onready var fps_label = $MarginContainer/ContainerRight/FPS


func setup(starter_health: int, total_waves: int, starter_cash: int) -> void:
	lives_label.text = "Lives: " + str(starter_health)
	cash_label.text = "Cash: " + str(starter_cash)
	wave_label.text = "Wave 1/" + str(total_waves)


func _process(_delta: float) -> void:
	fps_label.text = "fps " + str(Engine.get_frames_per_second())


func _on_health_change(data: Dictionary) -> void:
	lives_label.text = "Lives: " + str(data.get("lives"))


func _on_wave_change(data: Dictionary) -> void:
	wave_label.text = "Wave " + str(data.get("new_wave")) + "/" + str(data.get("total_waves"))


func _on_cash_change(data: Dictionary) -> void:
	cash_label.text = "Cash: " + str(data.get("cash"))
