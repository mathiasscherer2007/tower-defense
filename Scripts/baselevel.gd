extends Node3D

@onready var path: Path3D = $Path3D

var enemy_scene = preload("res://Scenes/Enemies/baseenemy.tscn")

func _ready() -> void:
	var path_follow = PathFollow3D.new()
	var enemy = enemy_scene.instantiate()
	enemy.setup(path_follow)
	path_follow.add_child(enemy)
	path.add_child(path_follow)
