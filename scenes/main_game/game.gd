extends Node2D

const CUSTOMER_SCENE = preload("res://scenes/main_game/customer.tscn")

signal day_is_finished()

@onready var minigame_node: Node2D = $Minigame
@onready var food_fryer_node: FoodFryer = $FoodFryer
@onready var daytime_timer: Timer = $DaytimeTimer

@onready var fishball_tray: TextureButton = $FoodItemsButtons/Fishball
@onready var kikiam_tray: TextureButton = $FoodItemsButtons/Kikiam
@onready var squidball_tray: TextureButton = $FoodItemsButtons/Squidball
@onready var kwekkwek_tray: TextureButton = $FoodItemsButtons/KwekKwek


var customer1_pos: Vector2 = Vector2(420, 200)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigame_node.connect("minigame_finished", _on_minigame_finished)
	
	# TEST BLOCK --------------------------
	spawn_customer()
	# -------------------------------------


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_food_items_buttons()
	
	
func update_food_items_buttons():
	if PlayerData.stock_items["fishball"] <= 0:
		fishball_tray.disabled = true
	else:
		fishball_tray.tooltip_text = "Fishball: " + str(PlayerData.stock_items["fishball"])
		fishball_tray.disabled = false
		 
	if PlayerData.stock_items["squidball"] <= 0:
		squidball_tray.disabled = true
	else:
		squidball_tray.tooltip_text = "Squidball: " + str(PlayerData.stock_items["squidball"])
		squidball_tray.disabled = false
		
	if PlayerData.stock_items["kikiam"] <= 0:
		kikiam_tray.disabled = true
	else:
		kikiam_tray.tooltip_text = "Kikiam: " + str(PlayerData.stock_items["kikiam"])
		kikiam_tray.disabled = false
		
	if PlayerData.stock_items["kwekkwek"] <= 0:
		kwekkwek_tray.disabled = true
	else:
		kwekkwek_tray.tooltip_text = "Kwekkwek: " + str(PlayerData.stock_items["kwekkwek"])
		kwekkwek_tray.disabled = false

func start_day():
	daytime_timer.start(120)
	
func _on_daytime_timer_timeout() -> void:
	emit_signal("day_is_finished")

func _on_fishball_pressed() -> void:
	if PlayerData.stock_items["fishball"] > 0:
		PlayerData.stock_items["fishball"] -= 1
		food_fryer_node.add_streetfood("fishball")


func _on_squidball_pressed() -> void:
	if PlayerData.stock_items["squidball"] > 0:
		PlayerData.stock_items["squidball"] -= 1
		food_fryer_node.add_streetfood("squidball")


func _on_kikiam_pressed() -> void:
	if PlayerData.stock_items["kikiam"] > 0:
		PlayerData.stock_items["kikiam"] -= 1
		food_fryer_node.add_streetfood("kikiam")


func _on_kwek_kwek_pressed() -> void:
	if PlayerData.stock_items["kwekkwek"] > 0:
		PlayerData.stock_items["kwekkwek"] -= 1
		food_fryer_node.add_streetfood("kwekkwek")
		

func spawn_customer():
	var customer_instance: Customer = CUSTOMER_SCENE.instantiate()
	$Customers.add_child(customer_instance)
	customer_instance.connect("start_minigame", _on_start_minigame)
	customer_instance.set_customer_pos(customer1_pos)
	
func _on_start_minigame(streetfood_name: String, order: OrderButton):
	minigame_node.start_minigame(streetfood_name, order)
	
func _on_minigame_finished(catched_count: int, catched_spoiled_count: int):
	minigame_node.visible = false
	print("CATCHED ITEMS COUNT: ", catched_count)
	print("CATCHED SPOILED ITEMS: ", catched_spoiled_count)
