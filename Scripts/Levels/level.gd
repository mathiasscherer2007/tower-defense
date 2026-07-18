class_name Level extends Node3D

# TODO: Create enemyspawn area
# Enemyspawn: Area where enemies are instantiated. Their hitbox only activates after leaving this area.

signal wave_change(data: Dictionary)
signal health_change(data: Dictionary)
signal cash_change(data: Dictionary)


@export_group("Scale Settings")
@export var entity_scale: Vector3 = Vector3(1, 1, 1)

var total_waves: int:
	get():
		return wave_handler.get_total_waves()

var current_wave: int:
	get():
		return wave_handler.wave_counter + 1

var current_lives: int:
	get():
		return player.lives

var cash: int:
	get():
		return player.cash

@onready var enemy_handler = $EnemyHandler
@onready var wave_handler = $WaveHandler
@onready var player = $Player
@onready var camera_handler = $CameraHandler


func _ready() -> void:
	enemy_handler.enemy_exit.connect(camera_handler._on_enemy_exit)
	enemy_handler.enemy_exit.connect(player._on_enemy_exit)
	enemy_handler.enemy_exit.connect(wave_handler._on_enemy_exit)

	enemy_handler.enemy_death.connect(player._on_enemy_death)
	enemy_handler.enemy_death.connect(wave_handler._on_enemy_death)
	
	wave_handler.wave_change.connect(_on_wave_change)
	player.health_change.connect(_on_player_health_change)
	player.cash_change.connect(_on_player_cash_change)

	wave_change.emit({ 
		"current_wave": current_wave, 
		"total_waves": total_waves
	})
	wave_handler.load_wave()


func _on_wave_change(data: Dictionary) -> void:
	wave_change.emit({
		"new_wave": data.get("new_wave"),
		"total_waves": total_waves
	})


func _on_player_health_change(data: Dictionary) -> void:
	health_change.emit({ "lives": data.get("lives") })


func _on_player_cash_change(data: Dictionary) -> void:
	cash_change.emit({ "cash": data.get("cash") })