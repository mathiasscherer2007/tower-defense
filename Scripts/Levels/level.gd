class_name Level extends Node3D

# TODO: Create enemyspawn area
# Enemyspawn: Area where enemies are instantiated. Their hitbox only activates after leaving this area.

# TODO: Componentize wave manager

signal wave_change(new_wave: int, total_waves: int)
signal health_change(new_health: int)

@export_group("Scale Settings")
@export var entity_scale: Vector3 = Vector3(1, 1, 1)
@export var speed_scale: float = 1
@export_group("")

var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()

@onready var enemy_handler = $EnemyHandler
@onready var wave_handler = $WaveHandler
@onready var player = $Player
@onready var camera = $Camera3D


func _ready() -> void:
	enemy_handler.enemy_exit.connect(player._on_enemy_exit)
	enemy_handler.enemy_exit.connect(_on_enemy_exit)
	
	enemy_handler.enemy_death.connect(wave_handler._on_enemy_death)
	enemy_handler.enemy_exit.connect(wave_handler._on_enemy_exit)
	
	wave_handler.wave_change.connect(_on_wave_change)
	
	player.health_change.connect(_on_player_health_change)
	
	var current_wave = wave_handler.wave_counter + 1
	
	wave_change.emit(current_wave, wave_handler.get_total_waves())
	wave_handler.load_wave()


func _on_enemy_exit(data: Dictionary) -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, 0.5*data.get("lives"), 0.0, 0.2)


func _on_wave_change(new_wave: int, total_waves: int) -> void:
	wave_change.emit(new_wave, total_waves)


func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity * Globals.screen_shake_mult
	camera.h_offset = camera_offset/5
	camera.v_offset = camera_offset/7


func _on_player_health_change(new_health: int) -> void:
	health_change.emit(new_health)
