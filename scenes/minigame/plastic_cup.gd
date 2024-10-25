extends Node2D

signal is_max_catch()

@onready var juice_content_bar: ProgressBar = $InnerCup/ProgressBar

var starting_y: int = 600

var current_catched_index: int = 0

var max_catched_index: int = 200

var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_cup(false)
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	global_position.x = get_global_mouse_position().x
	if global_position.x < 20: global_position.x = 20
	if global_position.x > 1260: global_position.x = 1260
	
	update_progress_value()

func activate_cup(to_on: bool):
	global_position.y = starting_y
	activated = to_on
	set_physics_process(to_on)

func update_progress_value():
	juice_content_bar.value = current_catched_index 
	juice_content_bar.max_value = max_catched_index

func reset():
	current_catched_index = 0
	juice_content_bar.value = 0

func move_to_center():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(640, 300), 1)

func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() and current_catched_index < max_catched_index:
		var droplet: JuiceDroplet = area.get_parent()
		droplet.queue_free()
		current_catched_index += 1
		print("CATCHED ITEM!")
		if current_catched_index >= max_catched_index and activated:
			emit_signal("is_max_catch")
