extends Shootable

var damage: float
var pierce: float

var direction: Vector3
var spawn_point: Vector3
var target: Vector3


func setup(args: Dictionary) -> void:
	self.target = args.get("target")
	self.spawn_point = args.get("spawn_point")
	
	self.damage = args.get("damage")
	self.pierce = args.get("pierce")


func _ready() -> void:
	direction = (target - spawn_point).normalized()


func _physics_process(_delta: float) -> void:
	var space_state := get_world_3d().direct_space_state
	var exclusion_list: Array[RID] = []
	var current_pos := spawn_point
	var current_end := current_pos + (direction * 100)
	
	while floor(pierce) > 0:
		var query = PhysicsRayQueryParameters3D.create(
			current_pos, 
			current_end, 
			0b00000000_00000000_00000000_00001001, 
			exclusion_list
		)
		query.collide_with_areas = true
		
		var result: Dictionary = space_state.intersect_ray(query)
		if result:
			var collider = result.get("collider")
			if collider.collision_layer == 8:
				break
				queue_free()
			if collider.collision_layer == 1:
				collider.emit_signal("take_damage", self.damage)
				pierce -= 1
			
			exclusion_list.append(result.get("rid"))
			current_pos = result.get("position")
			pierce -= 1
