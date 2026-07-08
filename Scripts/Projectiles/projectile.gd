class_name Projectile extends Area3D

@export var lifetime: float
@export var speed: float
@export var damage: float

var direction: Vector3
var spawn_point: Vector3
var target: Vector3

@onready var timer = $Timer

func setup(n_target: Vector3, n_spawner: Vector3) -> void:
	target = n_target
	spawn_point = n_spawner

func _ready() -> void:
	self.global_position = spawn_point
	self.look_at(target)
	timer.wait_time = lifetime
	timer.start()
	direction = (target - self.global_position).normalized()

func _physics_process(delta: float) -> void:
	self.global_position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

# TODO: Not everything disappears when touching geometry (I.E. grenades).
#       This could probably be a component.
func _on_area_entered(area: Area3D) -> void:
	# Delete projectile on contact with geometry
	if area.collision_layer == 8:
		queue_free()
