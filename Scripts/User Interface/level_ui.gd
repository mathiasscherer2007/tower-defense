extends Control

signal cash_change(data: Dictionary)

@onready var wave_label = $MarginContainer/Container/Wave
@onready var lives_label = $MarginContainer/Container/Lives
@onready var cash_label = $MarginContainer/Container/Cash
@onready var fps_label = $MarginContainer/ContainerRight/FPS


func _ready() -> void:
	for child in $MarginContainer/Control/TowerButtonContainer.get_children():
		cash_change.connect(child._on_cash_change)


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
	cash_change.emit({ "cash": data.get("cash") })


func get_tower_button_container() -> Container:
	return find_child("TowerButtonContainer", true)
