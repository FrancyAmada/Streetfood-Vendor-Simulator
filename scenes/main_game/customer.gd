extends Node2D

class_name Customer

@onready var sprite = $Sprite2D
const STREETFOOD_ORDER_SCENE = preload("res://scenes/main_game/order.tscn")

@export_enum('student', 'normal', 'rich') var character_type: String = 'normal'

signal start_minigame(streetfood_name: String, order: OrderButton)
signal remove_character()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var n = randi_range(0, 1)
	var gender = 'male' if (n==0) else 'female'
	sprite.texture = load('res://assets/customers/' + gender + '-' + character_type + '.png')
	generate_orders()
	
	# TEST BLOCK -------------------
	#add_order("juice")
	#add_order("chicken_siomai")
	# ------------------------------

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $PanelContainer/Orders.get_child_count() <= 0:
		remove_customer()

func set_customer_pos(pos: Vector2):
	global_position = pos

func add_order(streetfood_name: String):
	var order_instance: OrderButton = STREETFOOD_ORDER_SCENE.instantiate()
	$PanelContainer/Orders.add_child(order_instance)
	order_instance.set_streetfood(streetfood_name)
	order_instance.connect("start_minigame", _on_start_minigame)
	if get_parent().get_parent().get_parent().in_minigame:
		order_instance._on_minigame_started()

func _on_start_minigame(streetfood_name: String, order: OrderButton):
	emit_signal("start_minigame", streetfood_name, order)
	
func remove_customer():
	if is_instance_valid(self):
		emit_signal("remove_character")
		queue_free()

func generate_orders():
	var available_items: Array[String]
	for item in PlayerData.stock_items:
		if PlayerData.stock_items[item] != 0:
			available_items.append(item)
			
	if character_type == 'student':
		add_order(available_items.pick_random())
	
	if character_type == 'normal':
		var n = randi_range(0, 1)
		if n == 0: 
			add_order(available_items.pick_random())
		else:
			add_order(available_items.pick_random())
			add_order(available_items.pick_random())
		
	if character_type == 'rich':
		var n = randi_range(0, 9)
		if n < 3:
			add_order(available_items.pick_random())
			add_order(available_items.pick_random())
		else:
			add_order(available_items.pick_random())
			add_order(available_items.pick_random())
			add_order(available_items.pick_random())
