extends Area3D

var path_follow: PathFollow3D

@export var speed: int

# called when the scene is instatiated by the level
func setup(new_path_follow: PathFollow3D):
	path_follow = new_path_follow

# handles the movement and interactions
func _physics_process(delta: float) -> void:
	path_follow.progress += speed * delta
	
	if path_follow.progress_ratio >= 0.99:
		print('enemy exited!')
		queue_free()
