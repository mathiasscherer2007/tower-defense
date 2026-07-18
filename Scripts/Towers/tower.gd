class_name Tower extends Node3D


enum targeting_types {FIRST, LAST, CLOSE, STRONG} # will only implement first for now

## Radius of the range area in meters
@export var max_range: float
@export var targeting_type: targeting_types = targeting_types.FIRST
## Projectile shot by the tower
@export_group("Projectile Properties")
@export var projectile: PackedScene
@export var damage: float
@export var pierce: int = 1
@export var cooldown: float
@export var projectile_speed: float = 20
@export var projectile_lifetime: float = 1
@export_group("Mesh Properties")
## Meshes that look at target in all axis
@export var look_meshes: Array[Node3D]
## Meshes that look at target only in the Y axis
@export var rotate_meshes: Array[Node3D]

var projectile_args: Dictionary
var can_shoot: bool = true
var enemies_in_range: Array = []

@onready var range_area = $Range/CollisionShape3D
@onready var projectile_container = $Projectiles
@onready var projectile_spawn_point = find_child('ProjectileSpawnPoint')
@onready var range_decal = $RangeDecal


func _ready() -> void:
	if range_area.shape is SphereShape3D:
		range_area.shape.radius = max_range
	
	projectile_args = {
		"target": null,
		"spawn_point": null,
		"damage": self.damage,
		"pierce": self.pierce,
		"speed": self.projectile_speed,
		"lifetime": self.projectile_lifetime
	}
	
	range_decal.size = Vector3(max_range * 2, max_range * 2, max_range * 2)


func _process(_delta: float) -> void:
	if len(enemies_in_range) > 0:
		shoot()


func shoot() -> void:
	if can_shoot:
		self.can_shoot = false
		
		var target: Enemy = determine_target(targeting_type)
		var enemy_pos: Vector3 = target.get_center_position()
		
		for node in look_meshes:
			node.look_at(enemy_pos)
		for node in rotate_meshes:
			node.look_at(Vector3(enemy_pos.x, self.global_position.y, enemy_pos.z))
		
		var projectile_instance = projectile.instantiate()
		projectile_args["target"] = enemy_pos
		projectile_args["spawn_point"] = projectile_spawn_point.global_position
		
		projectile_instance.setup(projectile_args)
		projectile_container.add_child(projectile_instance)
		
		var timer = get_tree().create_timer(self.cooldown)
		timer.connect("timeout", _on_cooldown_timeout)


func determine_target(targeting: targeting_types) -> Enemy:
	var result = enemies_in_range[0]
	
	match targeting:
		targeting_types.FIRST:
			var dist = 0
			for enemy in enemies_in_range:
				var progress = enemy.get_path_progress().get("progress")
				if progress > dist:
					dist = progress
					result = enemy
		
		targeting_types.LAST:
			var dist = enemies_in_range[0].get_path_progress().get("progress")
			for enemy in enemies_in_range:
				var progress = enemy.get_path_progress().get("progress")
				if progress < dist:
					dist = progress
					result = enemy
		
		targeting_types.CLOSE:
			var smallest_distance = self.global_position.distance_to(enemies_in_range[0].global_position)
			for enemy in enemies_in_range:
				var distance = self.global_position.distance_to(enemy.global_position)
				if distance < smallest_distance:
					smallest_distance = distance
					result = enemy
		
		targeting_types.STRONG:
			var biggest_health = enemies_in_range[0].health
			for enemy in enemies_in_range:
				var health = enemy.health
				if health > biggest_health:
					biggest_health = health
					result = enemy
	
	return result


func _on_cooldown_timeout() -> void:
	self.can_shoot = true


func _on_range_area_entered(area: Area3D) -> void:
	if area.get_parent() not in enemies_in_range:
		enemies_in_range.append(area.get_parent())


func _on_range_area_exited(area: Area3D) -> void:
	if area.get_parent() in enemies_in_range:
		enemies_in_range.erase(area.get_parent())
