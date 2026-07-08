extends Level

var enemy_scene = preload("res://Scenes/Enemies/test/testbasic1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# temporary, calls superclass _ready function
	super()
	var enemy_path = PathFollow3D.new()
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.scale = enemy_scale
	enemy.speed *= enemy_speed_scale
	enemy.setup(enemy_path)
	enemy_path.add_child(enemy)
	path.add_child(enemy_path)
