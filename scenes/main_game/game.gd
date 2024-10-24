extends Node2D

const CUSTOMER_SCENE = preload("res://scenes/main_game/customer.tscn")

signal day_is_finished()

@onready var minigame_node: Node2D = $Minigame
@onready var food_fryer_node: FoodFryer = $FoodFryer
@onready var daytime_timer: Timer = $DaytimeTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigame_node.connect("minigame_finished", _on_minigame_finished)
	
	# TEST BLOCK --------------------------
	spawn_customer()
	# -------------------------------------


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_day():
	daytime_timer.start(60)
	
func _on_daytime_timer_timeout() -> void:
	emit_signal("day_is_finished")

func _on_fishball_pressed() -> void:
	food_fryer_node.add_streetfood("fishball")


func _on_squidball_pressed() -> void:
	food_fryer_node.add_streetfood("squidball")


func _on_kikiam_pressed() -> void:
	food_fryer_node.add_streetfood("kikiam")


func _on_kwek_kwek_pressed() -> void:
	food_fryer_node.add_streetfood("kwekkwek")



func spawn_customer():
	var customer_instance: Customer = CUSTOMER_SCENE.instantiate()
	$Customers.add_child(customer_instance)
	customer_instance.connect("start_minigame", _on_start_minigame)
	customer_instance.set_customer_pos(Vector2(340, 200))
	
func _on_start_minigame(streetfood_name: String):
	minigame_node.start_minigame(streetfood_name)
	
func _on_minigame_finished(catched_count: int):
	minigame_node.visible = false
	print("CATCHED ITEMS COUNT: ", catched_count)
