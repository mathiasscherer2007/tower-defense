class_name Tower extends Node3D

# TODO: more robust targeting system, make tower shoot enemy that is furthest in the track

var enemies: Array
@export var max_range: float
@onready var range_area = $Range/CollisionShape3D
@onready var timer = $Firerate

func _ready() -> void:
	if range_area.shape is CylinderShape3D:
		range_area.shape.radius = max_range
	print(range_area.shape.radius)

func _process(_delta: float) -> void:
	if timer.is_stopped():
		if len(enemies) > 0:
			var enemy_pos: Vector3 = enemies[0].global_position
			print(enemy_pos)
			self.look_at(Vector3(enemy_pos.x, self.global_position.y, enemy_pos.z))
			timer.start()

func _on_range_area_entered(area: Area3D) -> void:
	if area not in enemies:
		enemies.append(area)
		

func _on_range_area_exited(area: Area3D) -> void:
	if area in enemies:
		enemies.erase(area)
