class_name Enemy extends Node3D

signal reached_end(data)

@export var health: float
@export var speed: float
## Amount of lives this enemy takes upon reaching the end of the path
@export var weight: int = 1

var path_follow: PathFollow3D

func setup(n_path_follow: PathFollow3D):
	path_follow = n_path_follow

func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 0.99:
		reached_end.emit({ "lives": weight })
		queue_free()

func _process(_delta: float) -> void:
	# TODO: make elaborate signal for enemy death
	if health <= 0:
		queue_free()

func _on_collision_area_entered(_area: Area3D) -> void:
	# TODO: when bullets are implemented, reduce health based on bullet's damage
	pass
