class_name TowerButton extends Button

signal tower_selected(data: Dictionary)

@export var tower_scene: PackedScene
@export var price: int


func _ready() -> void:
	pressed.connect(_on_pressed)
	text = "$" + str(price)


func _on_pressed() -> void:
	if tower_scene != null:
		tower_selected.emit({ "scene": tower_scene, "price": price })


func _on_cash_change(data: Dictionary) -> void:
	if data.get("cash") >= price:
		self.disabled = false
	else:
		self.disabled = true
