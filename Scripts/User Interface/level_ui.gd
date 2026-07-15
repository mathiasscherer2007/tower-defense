extends Control

@onready var wave_label = $Wave
@onready var lives_label = $Lives


func setup(starter_health: int, total_waves: int) -> void:
	lives_label.text = "Lives: " + str(starter_health)
	wave_label.text = "Wave 1/" + str(total_waves)


func _on_health_change(lives: int) -> void:
	lives_label.text = "Lives: " + str(lives)


func _on_wave_change(new_wave: int, wave_total: int) -> void:
	wave_label.text = "Wave " + str(new_wave) + "/" + str(wave_total)
