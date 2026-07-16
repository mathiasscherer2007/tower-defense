extends Node3D

@onready var ui = $CanvasLayer/UI
@onready var level = $Level


func _ready() -> void:
	ui.setup(level.player.lives, level.wave_handler.get_total_waves())
	
	level.health_change.connect(ui._on_health_change)
	level.wave_change.connect(ui._on_wave_change)
