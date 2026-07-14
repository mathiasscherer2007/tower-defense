class_name SubWave

## Delay from start of wave, in milliseconds
var delay_wave: int
## Delay between enemies, in milliseconds
var delay_enemies: int
## Amount of enemies
var amount: int
## Enemy scene
var enemy: PackedScene

func _init(n_delay_wave: int, n_delay_enemies: int, n_amount: int, n_enemy: PackedScene) -> void:
    self.delay_wave = n_delay_wave
    self.delay_enemies = n_delay_enemies
    self.amount = n_amount
    self.enemy = n_enemy