extends Node2D

class_name Customer

const STREETFOOD_ORDER_SCENE = preload("res://scenes/main_game/order.tscn")

signal start_minigame(streetfood_name: String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_order("fishball")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_customer_pos(pos: Vector2):
	global_position = pos

func add_order(streetfood_name: String):
	var order_instance: OrderButton = STREETFOOD_ORDER_SCENE.instantiate()
	$PanelContainer/Orders.add_child(order_instance)
	order_instance.set_streetfood(streetfood_name)
	order_instance.connect("start_minigame", _on_start_minigame)

func _on_start_minigame(streetfood_name: String):
	emit_signal("start_minigame", streetfood_name)
	