extends Node2D

signal minigame_finished(catched_count: int, catched_spoiled_count: int)


@onready var stick_node: Node2D = $Stick
@onready var siomai_plate_node: Node2D = $SiomaiPlate
@onready var plastic_cup_node: Node2D = $PlasticCup
@onready var dropper_node: Node2D = $Dropper
@onready var juice_dropper: Node2D = $JuiceDropper

var current_streetfood: String = ""
var current_order = null
var finished: bool = false

var item_is_fried: bool = false
var item_is_siomai: bool = false
var item_is_juice: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_minigame()
	# TEST CODE BLOCK -------------------------
	#stick_node.activate_stick(true)
	#dropper_node.activate_spawner(true)
	#dropper_node.set_spawnable_item({'spawnable_count': 5})
	# -----------------------------------------

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func start_minigame(streetfood_name: String, order: OrderButton):
	AudioManager.play_minigame_start_sfx()
	finished = false
	current_order = order
	current_streetfood = streetfood_name
	set_minigame_type(streetfood_name)
	Global.emit_signal("minigame_started")
	visible = true
	if item_is_fried:
		if streetfood_name == "kwekkwek":
			stick_node.set_initial_catched_position(Vector2(0, 220))
		stick_node.set_max_catched_index(StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name])
		stick_node.activate_stick(true)
	if item_is_siomai:
		siomai_plate_node.set_max_catched_index(StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name])
		siomai_plate_node.activate_plate(true)
	if item_is_juice:
		plastic_cup_node.activate_cup(true)
		juice_dropper.activate_juice_dropper(true)
	else:
		dropper_node.activate_spawner(true)
		dropper_node.set_spawnable_item({
		'name': streetfood_name,
		'spawnable_count': StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name]
		})

func reset_minigame():
	stick_node.reset()
	siomai_plate_node.reset()
	plastic_cup_node.reset()
	item_is_fried = false
	item_is_juice = false
	item_is_siomai = false
	stick_node.visible = false
	stick_node.global_position = Vector2(-300, -300)
	siomai_plate_node.visible = false
	siomai_plate_node.global_position = Vector2(-300, -300)
	plastic_cup_node.visible = false
	plastic_cup_node.global_position = Vector2(-300, -300)

func set_minigame_type(food_name: String):
	if food_name in StreetfoodData.FRIED_STREETFOODS:
		item_is_fried = true
		stick_node.visible = true
	if food_name in StreetfoodData.SIOMAI_STREETFOODS:
		item_is_siomai = true
		siomai_plate_node.visible = true
	if food_name == "juice":
		item_is_juice = true
		plastic_cup_node.visible = true

func finish_minigame():
	finished = true
	await get_tree().create_timer(0.5).timeout
	dropper_node.activate_spawner(false)
	juice_dropper.activate_juice_dropper(false)
	if item_is_fried:
		stick_node.activate_stick(false)
		stick_node.move_to_center()
	if item_is_siomai:
		siomai_plate_node.activate_plate(false)
		siomai_plate_node.move_to_center()
	if item_is_juice:
		plastic_cup_node.activate_cup(false)
		plastic_cup_node.move_to_center()
	await get_tree().create_timer(2.5).timeout
	var catched_item_count: int = 0
	var catched_spoiled_count: int = 0
	if item_is_fried:
		catched_item_count = stick_node.current_catched_index
		catched_spoiled_count = stick_node.catched_spoiled_count
	if item_is_siomai:
		catched_item_count = siomai_plate_node.current_catched_index
		catched_spoiled_count = siomai_plate_node.catched_spoiled_count
	AudioManager.play_correct_order_sfx()
	if item_is_juice:
		catched_item_count = plastic_cup_node.current_catched_index
	emit_signal("minigame_finished", current_streetfood, catched_item_count, catched_spoiled_count)
	reset_minigame()
	
	if current_order != null and is_instance_valid(current_order):
		current_order.queue_free()
		current_order = null
		
	await get_tree().create_timer(1).timeout
	dropper_node.finished = false
	Global.emit_signal("minigame_finished")
	finished = false
	
func _on_dropper_is_finished() -> void:
	for i in range(9):
		await get_tree().create_timer(0.5).timeout
		if finished or current_order == null:
			return
	if !finished and current_order != null:
		finish_minigame()

func _on_stick_is_max_catch() -> void:
	if !finished and current_order != null:
		finish_minigame()

func _on_siomai_plate_is_max_catch() -> void:
	if !finished and current_order != null:
		finish_minigame()

func _on_juice_dropper_is_finished() -> void:
	for i in range(9):
		await get_tree().create_timer(0.5).timeout
		if finished or current_order == null:
			return
	if !finished and current_order != null:
		finish_minigame()

func _on_plastic_cup_is_max_catch() -> void:
	if !finished and current_order != null:
		finish_minigame()
