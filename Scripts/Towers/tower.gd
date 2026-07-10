class_name Tower extends Node3D

# TODO: more robust targeting system, make tower shoot enemy that is furthest in the track

## Radius of the range area in meters
@export var max_range: float
## Projectile shot by the tower
@export_group("Projectile Properties")
@export var projectile: PackedScene
@export var damage: float = 1
## How many enemies this tower's projectile pierces before disappearing
@export var pierce: int = 1
## How fast this tower's projectile goes
@export var projectile_speed: float = 10
## Tower's projectile lifetime in seconds
@export var projectile_lifetime: float = 1

var enemies: Array

@onready var mesh = $Mesh
@onready var range_area = $Range/CollisionShape3D
@onready var cooldown = $Cooldown
@onready var projectile_container = $Projectiles
@onready var projectile_spawn_point = find_child('ProjectileSpawnPoint')

func _ready() -> void:
	if range_area.shape is CylinderShape3D:
		range_area.shape.radius = max_range

func _process(_delta: float) -> void:
	if len(enemies) > 0:
		shoot(enemies[0])

func shoot(enemy: Area3D) -> void:
	if cooldown.is_stopped():
		var enemy_pos: Vector3 = enemy.global_position
		var projectile_instance = projectile.instantiate()
		var projectile_spawn_position = projectile_spawn_point.global_position
		
		projectile_instance.setup(enemy_pos, projectile_spawn_position, damage, projectile_speed, pierce, projectile_lifetime)
		projectile_container.add_child(projectile_instance)
		
		mesh.look_at(Vector3(enemy_pos.x, self.global_position.y, enemy_pos.z))
		
		cooldown.start()

func _on_range_area_entered(area: Area3D) -> void:
	if area not in enemies:
		enemies.append(area)

func _on_range_area_exited(area: Area3D) -> void:
	if area in enemies:
		enemies.erase(area)
