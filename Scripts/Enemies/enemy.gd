class_name Enemy extends Node3D


signal reached_end(data)
signal died(data)

@export var health: float
@export var speed: float
@export var cash_on_defeat: int
## Amount of lives this enemy takes upon reaching the end of the path
@export var weight: int = 1

@onready var health_number = $Health
@onready var center = $Center

var path_follow: PathFollow3D


func setup(n_path_follow: PathFollow3D):
	path_follow = n_path_follow
	path_follow.set_loop(false)


func _ready() -> void:
	health_number.text = str(int(ceil(health)))


func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 0.99:
		reached_end.emit({ "lives": weight })
		queue_free()


func _on_collision_take_damage(damage: float) -> void:
	health -= damage
	
	if health <= 0:
		died.emit({ "cash": self.cash_on_defeat })
		queue_free()
	
	health_number.text = str(int(ceil(health)))


func get_center_position() -> Vector3:
	return center.global_position


func get_path_progress() -> Dictionary:
	return {
		"progress": path_follow.get_progress(),
		"progress_ratio": path_follow.get_progress_ratio()
	}
