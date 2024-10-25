extends Node2D

signal is_finished()

const JUICE_DROPLET_SCENE = preload("res://scenes/minigame/juice_droplet.tscn")

@onready var drop_timer: Timer = $Timer

var activated: bool = false
var finished: bool = false

var interval_counter: float = 0

func _ready() -> void:
	activate_juice_dropper(false)
	
func _process(delta: float) -> void:
	if activated:
		interval_counter += delta
		if interval_counter >= 0.08:
			for i in randi_range(4, 8):
				spawn_juice_droplet()
			interval_counter = 0
	
func activate_juice_dropper(to_on: bool):
	activated = to_on
	set_process(to_on)
	if to_on:
		drop_timer.start(6)
	else:
		drop_timer.stop()
		
func spawn_juice_droplet():
	var droplet_instance = JUICE_DROPLET_SCENE.instantiate()
	var rand_x: int = randi_range(30, 1250)
	add_child(droplet_instance)
	droplet_instance.set_droplet_position(Vector2(rand_x, -100))

func _on_timer_timeout() -> void:
	emit_signal("is_finished")
