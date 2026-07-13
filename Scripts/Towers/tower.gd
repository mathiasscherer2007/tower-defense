class_name Tower extends Node3D

# TODO: more robust targeting system, make tower shoot enemy that is furthest in the track

## Radius of the range area in meters
@export var max_range: float
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
## Meshes that look at target but don't rotate on the Y axis
@export var rotate_meshes: Array[Node3D]

var projectile_args: Dictionary
var can_shoot: bool = true
var enemies: Array

@onready var range_area = $Range/CollisionShape3D
@onready var projectile_container = $Projectiles
@onready var projectile_spawn_point = find_child('ProjectileSpawnPoint')


func _ready() -> void:
	if range_area.shape is CylinderShape3D:
		range_area.shape.radius = max_range
	
	projectile_args = {
		"target": null,
		"spawn_point": null,
		"damage": self.damage,
		"pierce": self.pierce,
		"speed": self.projectile_speed,
		"lifetime": self.projectile_lifetime
	}


func _process(_delta: float) -> void:
	if len(enemies) > 0:
		shoot(enemies[0])


func shoot(enemy: Area3D) -> void:
	if can_shoot:
		self.can_shoot = false
		
		var enemy_pos: Vector3 = enemy.global_position
		
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


func _on_cooldown_timeout() -> void:
	self.can_shoot = true


func _on_range_area_entered(area: Area3D) -> void:
	if area not in enemies:
		enemies.append(area)


func _on_range_area_exited(area: Area3D) -> void:
	if area in enemies:
		enemies.erase(area)
