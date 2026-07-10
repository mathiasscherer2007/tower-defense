class_name Projectile extends Area3D

var damage: float
var speed: float
var pierce: int = 1
var lifetime: float = 1.0

var direction: Vector3
var spawn_point: Vector3
var target: Vector3


func setup(
	n_target: Vector3,
	n_spawner: Vector3,
	n_damage: float,
	n_speed: float,
	n_pierce: int,
	n_lifetime: float
) -> void:
	self.target = n_target
	self.spawn_point = n_spawner

	self.damage = n_damage
	self.speed = n_speed
	self.pierce = n_pierce
	self.lifetime = n_lifetime


func _ready() -> void:
	self.global_position = spawn_point
	self.look_at(target)
	
	var lifetime_timer = get_tree().create_timer(lifetime)
	lifetime_timer.connect("timeout", _on_lifetime_timeout)

	direction = (target - self.global_position).normalized()


func _physics_process(delta: float) -> void:
	if pierce == 0:
		queue_free()
	self.global_position += direction * speed * delta


func _on_lifetime_timeout() -> void:
	queue_free()


# TODO: Not everything disappears when touching geometry (I.E. grenades).
#       This could probably be a component.
func _on_area_entered(area: Area3D) -> void:
	if area.collision_layer == 1:
		area.emit_signal("take_damage", damage)
		pierce -= 1
	# Delete projectile on contact with geometry
	if area.collision_layer == 8:
		queue_free()
