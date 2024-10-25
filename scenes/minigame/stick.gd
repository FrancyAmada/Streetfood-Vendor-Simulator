extends Node2D

signal is_max_catch()


@onready var items_node: Node2D = $ItemsNode

var starting_y: int = 600

var initial_catched_position: Vector2 = Vector2(0, 300)
var current_catched_index: int = 0
var catched_spoiled_count: int = 0

var max_catched_index: int = 5

var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_stick(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	global_position.x = get_global_mouse_position().x
	if global_position.x < 20: global_position.x = 20
	if global_position.x > 1260: global_position.x = 1260

func activate_stick(to_on: bool):
	activated = to_on
	set_physics_process(to_on)

func set_max_catched_index(max_num: int):
	max_catched_index = max_num

func set_initial_catched_position(pos: Vector2):
	initial_catched_position = pos

func reset():
	for child in items_node.get_children():
		items_node.remove_child(child)
	global_position.y = starting_y
	current_catched_index = 0
	catched_spoiled_count = 0
	initial_catched_position = Vector2(0, 300)

func move_to_center():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(640, 300), 1)

func _on_stick_head_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and current_catched_index < max_catched_index:
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			streetfood_item.catch_streetfood(self)
			current_catched_index += 1
			if streetfood_item.is_spoiled:
				catched_spoiled_count += 1
			print("CATCHED ITEM!")
			if current_catched_index >= max_catched_index and activated:
				emit_signal("is_max_catch")
