extends Node3D


@onready var ui = $CanvasLayer/UI
@onready var level = $Level


func _ready() -> void:
	ui.setup(level.current_lives, level.total_waves, level.cash)
	
	level.health_change.connect(ui._on_health_change)
	level.wave_change.connect(ui._on_wave_change)
	level.cash_change.connect(ui._on_cash_change)
	
	level.setup({
		"ui-button-container": ui.get_tower_button_container()
	})
