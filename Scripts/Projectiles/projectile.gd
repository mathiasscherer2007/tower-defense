class_name Projectile extends Area3D

@export var target: Vector3
@export var spawn_point: Node3D
@export var lifetime: float
@export var speed: float
@export var damage: float

var direction: Vector3

@onready var timer = $Timer

func setup(n_target: Vector3, n_spawner: Node3D) -> void:
	target = n_target
	spawn_point = n_spawner

func _ready() -> void:
	self.global_transform = spawn_point.global_transform
	look_at(target)
	timer.wait_time = lifetime
	timer.start()
	direction = (target - self.global_position).normalized()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
