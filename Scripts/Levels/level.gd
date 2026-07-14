class_name Level extends Node3D

# TODO: Create enemyspawn and base areas
# Enemyspawn: Area where enemies are instantiated. Their hitbox only activates after leaving this area.
# Base: area that triggers player damage when an enemy enters it.

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
		SubWave.new(100000, 1000, 3, load("res://Scenes/Enemies/test/testbasic1.tscn"))
	]
]
"""
    [
        [
            (
                delayWave: 1000,   # Delay from start of the wave <- One-shot timer created on wave start
                delayEnemies: 400, # Delay between enemies        <- Timer created after previous timer timeout() call
                amount: 3,         # Number of enemies spawned    <- n+1 of times the delayEnemies timer calls before being destroyed
                enemy: *path to enemy scene*                      <- Scene that is instantiated every time delayEnemies timeout() is called
            )
        ]
    ]

    on wave start, creates a bunch of delayWave timers
"""

var wave_counter = 0:
	set(value):
		wave_counter = value

var wave_start_timers: Array

@onready var path = $Path3D
@onready var player = $Player


func _ready() -> void:
	path.enemy_exit.connect(player._on_enemy_exit)
	load_wave()


func load_wave() -> void:
	for subwave: SubWave in waves[wave_counter]:
		var start_timer = get_tree().create_timer(subwave.delay_wave/1000.0)
		var callable = load_subwave.bind(subwave.delay_enemies, subwave.amount, subwave.enemy)
		start_timer.timeout.connect(callable)
		wave_start_timers.append(start_timer)

func load_subwave(delay_enemies, amount, enemy) -> void:
	for i in range(amount):
		spawn_enemy(enemy)
		if i < amount - 1:
			await get_tree().create_timer(delay_enemies/1000,0).timeout

func spawn_enemy(enemy: PackedScene) -> void:
	var path_follow = PathFollow3D.new()
	var enemy_instance = enemy.instantiate()
	enemy_instance.setup(path_follow)
	path_follow.add_child(enemy_instance)
	path.add_child(path_follow)
	
