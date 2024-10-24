extends Node2D

signal minigame_finished(catched_count: int)


@onready var stick_node: Node2D = $Stick
@onready var dropper_node: Node2D = $Dropper


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

func start_minigame(streetfood_name: String):
	visible = true
	stick_node.activate_stick(true)
	dropper_node.activate_spawner(true)
	dropper_node.set_spawnable_item({'name': 'fishball','spawnable_count': 5})

func reset_minigame():
	stick_node.reset()

func finish_minigame():
	dropper_node.activate_spawner(false)
	await get_tree().create_timer(3).timeout
	stick_node.activate_stick(false)
	stick_node.move_to_center()
	await get_tree().create_timer(1.5).timeout
	emit_signal("minigame_finished", stick_node.current_catched_index)
	reset_minigame()

func _on_dropper_is_finished() -> void:
	finish_minigame()

func _on_stick_is_max_catch() -> void:
	finish_minigame()
