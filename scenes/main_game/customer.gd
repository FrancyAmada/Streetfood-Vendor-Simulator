extends Node2D

class_name Customer

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
const STREETFOOD_ORDER_SCENE = preload("res://scenes/main_game/order.tscn")

@export_enum('student', 'normal', 'rich') var character_type: String = 'normal'

signal start_minigame(streetfood_name: String, order: OrderButton)
signal removed_character(customer: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var idle_anim = "idle_anim" + str(randi_range(1, 2))
	animation_player.play(idle_anim)
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
		emit_signal("removed_character", get_parent().name)
		queue_free()

func generate_orders():
	var available_items: Array[String]
	for item in PlayerData.stock_items:
		if PlayerData.stock_items[item] != 0 or PlayerData.cooked_items[item] != 0:
			available_items.append(item)
			
	var extra_order_chance = 1 + (PlayerData.reputation / 100)
	var orders_to_add = []

	if get_parent().get_parent().get_parent().is_out_of_stock() or len(available_items) > 0:
		return

	match character_type:
		"student":
			orders_to_add.append(available_items.pick_random())
			if randf() < extra_order_chance:
				orders_to_add.append(available_items.pick_random())
		
		"normal":
			var base_orders = randi_range(1, 2)
			for i in range(base_orders):
				orders_to_add.append(available_items.pick_random())
			if randf() < extra_order_chance:
				orders_to_add.append(available_items.pick_random())
		
		"rich":
			var base_orders = randi_range(2, 3)
			for i in range(base_orders):
				orders_to_add.append(available_items.pick_random())

	for order in orders_to_add:
		add_order(order)
