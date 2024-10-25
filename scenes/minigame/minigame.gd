extends Node2D

signal minigame_finished(catched_count: int, catched_spoiled_count: int)


@onready var stick_node: Node2D = $Stick
@onready var dropper_node: Node2D = $Dropper


var current_order = null
var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# TEST CODE BLOCK -------------------------
	#stick_node.activate_stick(true)
	#dropper_node.activate_spawner(true)
	#dropper_node.set_spawnable_item({'spawnable_count': 5})
	# -----------------------------------------

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_minigame(streetfood_name: String, order: OrderButton):
	finished = false
	current_order = order
	Global.emit_signal("minigame_started")
	visible = true
	if streetfood_name == "kwekkwek":
		stick_node.set_initial_catched_position(Vector2(0, 220))
	stick_node.set_max_catched_index(StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name])
	stick_node.activate_stick(true)
	dropper_node.activate_spawner(true)
	dropper_node.set_spawnable_item({
		'name': streetfood_name,
		'spawnable_count': StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name]
		})

func reset_minigame():
	stick_node.reset()

func finish_minigame():
	finished = true
	await get_tree().create_timer(0.5).timeout
	dropper_node.activate_spawner(false)
	stick_node.activate_stick(false)
	stick_node.move_to_center()
	await get_tree().create_timer(2.5).timeout
	emit_signal("minigame_finished", stick_node.current_catched_index, stick_node.catched_spoiled_count)
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
