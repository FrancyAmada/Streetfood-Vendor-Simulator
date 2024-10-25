extends Node2D

signal is_max_catch()


@onready var items_node: Node2D = $ItemsNode

var starting_y: int = 580

var current_catched_index: int = 0
var catched_spoiled_count: int = 0

var left_area_catched: bool = false
var middle_area_catched: bool = false
var right_area_catched: bool = false

var max_catched_index: int = 5

var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_plate(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	global_position.x = get_global_mouse_position().x
	if global_position.x < 20: global_position.x = 20
	if global_position.x > 1260: global_position.x = 1260

func activate_plate(to_on: bool):
	global_position.y = starting_y
	activated = to_on
	set_physics_process(to_on)

func set_max_catched_index(max_num: int):
	max_catched_index = max_num

func reset():
	for child in items_node.get_children():
		items_node.remove_child(child)
	global_position.y = starting_y
	current_catched_index = 0
	catched_spoiled_count = 0

func move_to_center():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(640, 300), 1)

func _on_stick_head_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and current_catched_index < max_catched_index:
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			streetfood_item.catch_streetfood(self)
			AudioManager.play_correct_catch_sfx()
			current_catched_index += 1
			if streetfood_item.is_spoiled:
				AudioManager.play_wrong_catch_sfx()
				catched_spoiled_count += 1
			print("CATCHED ITEM!")
			if current_catched_index >= max_catched_index and activated:
				emit_signal("is_max_catch")

func catch_streetfood(item: DroppingStreetfood):
	item.catch_streetfood(self)
	current_catched_index += 1
	if item.is_spoiled:
		catched_spoiled_count += 1
	print("CATCHED ITEM!")
	if current_catched_index >= max_catched_index and activated:
		emit_signal("is_max_catch")

func _on_left_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and !left_area_catched:
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			left_area_catched = true
			catch_streetfood(streetfood_item)
			streetfood_item.set_siomai_plate_position(self, $CatchAreas/LeftArea.position + Vector2(0, -80))
			
func _on_middle_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and !middle_area_catched:
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			middle_area_catched = true
			catch_streetfood(streetfood_item)
			streetfood_item.set_siomai_plate_position(self, $CatchAreas/MiddleArea.position + Vector2(0, -80))
			
func _on_right_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and !right_area_catched:
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			right_area_catched = true
			catch_streetfood(streetfood_item)
			streetfood_item.set_siomai_plate_position(self, $CatchAreas/RightArea.position + Vector2(0, -80))
