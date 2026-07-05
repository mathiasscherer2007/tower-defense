class_name Level extends Node3D

@export var enemy_scale: Vector3
@export var enemy_speed_scale: float
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

# var test_enemy = preload("");

func _ready() -> void:
	print("level loaded!")
