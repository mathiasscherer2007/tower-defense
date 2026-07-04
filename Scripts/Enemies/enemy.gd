class_name Enemy extends Node3D

@export var health: int;
@export var speed: int;
var path_follow: PathFollow3D;

func setup(new_path_follow: PathFollow3D):
	path_follow = new_path_follow

func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta

func _process(_delta: float) -> void:
	# TODO: make elaborate signal for enemy death
	if health <= 0:
		queue_free()
	if path_follow.progress_ratio >= 0.999:
		queue_free()

func _on_collision_area_entered(_area: Area3D) -> void:
	# TODO: when bullets are implemented, reduce health based on bullet's damage
	pass
