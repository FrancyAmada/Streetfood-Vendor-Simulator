extends Node2D

signal is_finished()

const DROPPING_STREETFOOD_SCENE = preload("res://scenes/minigame/dropping_streetfood.tscn")

@onready var spawn_timer: Timer = $SpawnTimer

var spawnable_items_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_spawner(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_timer.is_stopped() and spawnable_items_count > 0:
		spawn_timer.start(1.5)
	
	if spawnable_items_count <= 0:
		activate_spawner(false)
		emit_signal("is_finished")

func activate_spawner(to_on: bool):
	set_process(to_on)
	if to_on:
		spawn_timer.start(1.5)
	else:
		spawn_timer.stop()
		
	
func set_spawnable_item(item):
	spawnable_items_count = item.spawnable_count

func _on_spawn_timer_timeout() -> void:
	spawnable_items_count -= 1
	var item_pos_x: int = randi_range(80, 1200)
	var streetfood_item_instance: DroppingStreetfood = DROPPING_STREETFOOD_SCENE.instantiate()
	add_child(streetfood_item_instance)
	streetfood_item_instance.set_x_position(item_pos_x)
	print("SPAWNING ITEM AT ", item_pos_x)
	await get_tree().create_timer(1).timeout
	streetfood_item_instance.start_drop()
	print("DROPPING ITEM")
	print("REMAINING ITEMS: ", spawnable_items_count)
	