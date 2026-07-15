extends Node3D

signal wave_change(new_wave: int, total_waves: int)

@export var waves: Array = [
	[
		SubWave.new(0, 1000, 3, load("res://Scenes/Enemies/test/testbasic1.tscn")),
		SubWave.new(3000, 3000, 5, load("res://Scenes/Enemies/test/testbasic1.tscn"))
	],
	[
		SubWave.new(500, 600, 10, load("res://Scenes/Enemies/test/testbasic1.tscn"))
	]
]

var wave_counter: int = 0:
	set(value):
		wave_counter = value
	get():
		return wave_counter
var wave_enemy_counter: int = 0

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
	get_parent().enemy_handler.add_child(path_follow)


func _on_enemy_death(_data: Dictionary) -> void:
	wave_enemy_counter -= 1
	check_wave_end()


func check_wave_end() -> void:
	if wave_enemy_counter == 0 && len(waves) > wave_counter+1:
		await get_tree().create_timer(5).timeout
		wave_counter += 1
		wave_change.emit(wave_counter+1, len(waves))
		load_wave()


func _on_enemy_exit(_data: Dictionary) -> void:
	wave_enemy_counter -= 1
	check_wave_end()


func get_total_waves() -> int:
	return len(waves)
