class_name Level extends Node3D

# TODO: Create enemyspawn area
# Enemyspawn: Area where enemies are instantiated. Their hitbox only activates after leaving this area.

# TODO: Componentize wave manager

@export_group("Scale Settings")
@export var entity_scale: Vector3 = Vector3(1, 1, 1)
@export var speed_scale: float = 1
@export_group("")
@export var waves: Array = [
	[
		SubWave.new(0, 1000, 3, load("res://Scenes/Enemies/test/testbasic1.tscn")),
		SubWave.new(3000, 3000, 5, load("res://Scenes/Enemies/test/testbasic1.tscn"))
	],
	[
		SubWave.new(500, 600, 10, load("res://Scenes/Enemies/test/testbasic1.tscn"))
	]
]

var wave_counter = 0:
	set(value):
		wave_counter = value
var wave_enemy_counter = 0

var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()
var spawning: bool = false

@onready var enemy_handler = $EnemyHandler
@onready var player = $Player
@onready var camera = $Camera3D


func _ready() -> void:
	enemy_handler.enemy_exit.connect(player._on_enemy_exit)
	enemy_handler.enemy_exit.connect(_on_enemy_exit)
	enemy_handler.enemy_death.connect(_on_enemy_death)
	
	load_wave()


func load_wave() -> void:
	for subwave: SubWave in waves[wave_counter]:
		var start_timer = get_tree().create_timer(subwave.delay_wave/1000.0)
		var callable = load_subwave.bind(subwave.delay_enemies, subwave.amount, subwave.enemy)
		start_timer.timeout.connect(callable)


func load_subwave(delay_enemies: int, amount: int, enemy: PackedScene) -> void:
	wave_enemy_counter += amount
	for i in range(amount):
		spawn_enemy(enemy)
		if i < amount - 1:
			await get_tree().create_timer(delay_enemies/1000.0).timeout


func spawn_enemy(enemy: PackedScene) -> void:
	var path_follow = PathFollow3D.new()
	var enemy_instance = enemy.instantiate()
	enemy_instance.setup(path_follow)
	path_follow.add_child(enemy_instance)
	enemy_handler.add_child(path_follow)


func _on_enemy_death(_data: Dictionary) -> void:
	wave_enemy_counter -= 1
	check_wave_end()


func _on_enemy_exit(data: Dictionary) -> void:
	wave_enemy_counter -= 1
	check_wave_end()
	
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, 0.5*data.get("lives"), 0.0, 0.2)


func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity * Globals.screen_shake_mult
	camera.h_offset = camera_offset/5
	camera.v_offset = camera_offset/7


func check_wave_end() -> void:
	if wave_enemy_counter == 0 && player.lives > 0:
		await get_tree().create_timer(5).timeout
		wave_counter += 1
		load_wave()
