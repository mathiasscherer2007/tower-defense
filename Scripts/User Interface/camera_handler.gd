extends Node3D


var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()
var base_camera_data: Dictionary = {}
var is_resetting_camera: bool = false
var selected_tower: Tower = null

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
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var space_state = get_world_3d().direct_space_state
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.set_collide_with_areas(true)
		query.set_collide_with_bodies(false)
		query.set_collision_mask(0b00000000_00000000_00000000_00000100)
		var result = space_state.intersect_ray(query)
		
		var clicked_tower = null
		if result and result.get("collider"):
			clicked_tower = result.get("collider").get_parent()
		if selected_tower:
			selected_tower.toggle_select()
		if clicked_tower != selected_tower:
			selected_tower = clicked_tower
			if selected_tower:
				selected_tower.toggle_select()
		else:
			selected_tower = null
		## TODO: make a signal that is fired when a tower is selected to display
		##       it's stats on the UI


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
	
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.set_collide_with_areas(true)
	query.set_collide_with_bodies(false)
	query.set_collision_mask(0b00000000_00000000_00000000_00000100)
	var result = space_state.intersect_ray(query)
	if result:
		pass
	# TODO: Make a pointer that appears below a hovered tower, and stays 
	#       there when the tower is selected


func _on_enemy_exit(data) -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, 0.5 * data.get("lives"), 0.0, 0.2)


func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity * Globals.screen_shake_mult
	camera.h_offset = camera_offset/5
	camera.v_offset = camera_offset/7
