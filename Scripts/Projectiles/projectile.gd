class_name Projectile extends Area3D

@export var lifetime: float
@export var speed: float
@export var damage: float

var direction: Vector3
var target: Vector3
var spawn_point: Node3D

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

func _on_area_entered(area: Area3D) -> void:
	# Delete projectile on contact with geometry
	print(area.collision_layer)
	if area.collision_layer == 8:
		queue_free()
