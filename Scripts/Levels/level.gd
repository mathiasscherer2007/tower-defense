class_name Level extends Node3D

@export var entity_scale: Vector3 = Vector3(1, 1, 1)
@export var speed_scale: float = 1
@export var waves: Dictionary
"""
    {
        1: {
                delayWave: 1000,   # Delay from start of the wave
                delayEnemies: 400, # Delay between enemies
                amount: 3,         # Number of enemies spawned
                enemy: *path to enemy scene*
            };
    }

    on wave start, creates a bunch of timers that send a signal to spawn their enemies
"""

@onready var path = $Path3D
@onready var player = $Player

# var test_enemy = preload("");

func _ready() -> void:
	path.enemy_exit.connect(player._on_enemy_exit)
