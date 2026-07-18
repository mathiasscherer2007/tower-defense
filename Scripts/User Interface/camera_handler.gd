extends Node3D


var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()
var base_camera_data: Dictionary = {}
var is_resetting_camera: bool = false

@onready var camera = $Camera3D
@onready var top_view = $TopView


func _ready() -> void:
	base_camera_data.set("camera_position", camera.position)
	base_camera_data.set("camera_rotation", camera.rotation)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MoveCameraUp"):
		camera.position = top_view.position
		camera.rotation.x = deg_to_rad(-90)
	
	if event.is_action_released("MoveCameraUp"):
		camera.position = base_camera_data.get("camera_position")
		camera.rotation.x = base_camera_data.get("camera_rotation").x


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("MoveCameraRight"):
		is_resetting_camera = false
		self.rotation.y += deg_to_rad(1)
	
	if Input.is_action_pressed("MoveCameraLeft"):
		is_resetting_camera = false
		self.rotation.y += deg_to_rad(-1)
	
	if Input.is_action_just_pressed("ResetCamera"):
		self.rotation.y = fposmod(self.rotation.y + PI, TAU) - PI
		is_resetting_camera = true
	
	if is_resetting_camera:
		self.rotation.y = lerp(self.rotation.y, 0.0, 10 * delta)
		if is_equal_approx(self.rotation.y, 0.0):
			self.rotation.y = 0.0
			is_resetting_camera = false


func _on_enemy_exit(data) -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, 0.5 * data.get("lives"), 0.0, 0.2)


func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity * Globals.screen_shake_mult
	camera.h_offset = camera_offset/5
	camera.v_offset = camera_offset/7
