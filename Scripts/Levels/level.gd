class_name Level extends Node3D

var waves: Dictionary;
"""
    {
        1: {
                delayWave: 1000,   # Delay from start of the wave
                delayEnemies: 400, # Delay between enemies
                enemy: *path to enemy scene*
            };
    }

    on wave start, creates a bunch of timers that send a signal to spawn their enemies
"""