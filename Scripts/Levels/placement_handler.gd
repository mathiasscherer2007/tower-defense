class_name PlacementHandler extends Node3D


signal tower_placed(data: Dictionary)

@export var camera_handler: CameraHandler

var selected_tower_scene: PackedScene
var price: int
var preview_node: Node3D = null


func setup(button_container: Container) -> void:
	for button in button_container.get_children():
		if button is TowerButton:
			button.tower_selected.connect(_on_tower_selected)


func _on_tower_selected(data: Dictionary) -> void:
	selected_tower_scene = data.get("scene")
	price = data.get("price")
	
	if preview_node:
		preview_node.queue_free()
	
	preview_node = selected_tower_scene.instantiate()
	add_child(preview_node)
	var cam_pos = camera_handler.get_camera_position()
	if preview_node.global_rotation != Vector3(cam_pos.x, preview_node.global_position.y, cam_pos.z):
		preview_node.look_at(Vector3(cam_pos.x, preview_node.global_position.y, cam_pos.z))


func _physics_process(_delta: float) -> void:
	if preview_node:
		var pos = camera_handler.mousepos_raycast(0b00000000_00000000_00000000_01001000).get("position")
		if pos:
			preview_node.global_position = pos


func _input(event: InputEvent) -> void:
	if selected_tower_scene != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			tower_placed.emit({
				"scene": selected_tower_scene,
				"position": camera_handler.mousepos_raycast(0b00000000_00000000_00000000_00001000).get("position"),
				"rotation": preview_node.global_rotation,
				"price": price
			})
			cancel_placement()
		
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()


func cancel_placement() -> void:
	if preview_node:
		preview_node.queue_free()
		preview_node = null
	selected_tower_scene = null
	price = 0
