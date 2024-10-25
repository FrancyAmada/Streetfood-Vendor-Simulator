extends Node2D

const CUSTOMER_SCENE = preload("res://scenes/main_game/customer.tscn")

signal minigame_has_finished()
signal day_is_finished()
signal received_tip(amount: int)

@export_enum("street", "school", "mall") var location : String = "street"

@onready var minigame_node: Node2D = $Minigame
@onready var food_fryer_node: FoodFryer = $FoodFryer

@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer
@onready var daytime_timer: Timer = $DaytimeTimer

@onready var fishball_tray: TextureButton = $FoodItemsButtons/Fishball
@onready var kikiam_tray: TextureButton = $FoodItemsButtons/Kikiam
@onready var squidball_tray: TextureButton = $FoodItemsButtons/Squidball
@onready var kwekkwek_tray: TextureButton = $FoodItemsButtons/KwekKwek

@onready var customer_points: Array = $Customers.get_children()

var can_spawn: bool = false
var in_minigame: bool = false

var customer1: Customer = null
var customer1_pos: Vector2 = Vector2(420, 200)

var customer2: Customer = null
var customer2_pos: Vector2 = Vector2(560, 200)

var customer3: Customer = null
var customer3_pos: Vector2 = Vector2(720, 200)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minigame_node.connect("minigame_finished", _on_minigame_finished)
	generate_customers()
	if !customer1 or !customer2 or !customer3:
		spawn_interval_timer.start(MapData.MAP_SPAWN_INTERVAL[location])
	# TEST BLOCK --------------------------
	# -------------------------------------


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_food_items_buttons()
	update_siomai_steamer()
	update_juice_dispenser()
	if can_spawn:
		generate_customers()
	if is_out_of_stock():
		end_day()
	
	
func update_food_items_buttons():
	if PlayerData.stock_items["fishball"] <= 0:
		fishball_tray.disabled = true
	else:
		fishball_tray.disabled = false
		 
	if PlayerData.stock_items["squidball"] <= 0:
		squidball_tray.disabled = true
	else:
		squidball_tray.disabled = false
		
	if PlayerData.stock_items["kikiam"] <= 0:
		kikiam_tray.disabled = true
	else:
		kikiam_tray.disabled = false
		
	if PlayerData.stock_items["kwekkwek"] <= 0:
		kwekkwek_tray.disabled = true
	else:
		kwekkwek_tray.disabled = false
		
	fishball_tray.tooltip_text = "Fishball: " + str(PlayerData.stock_items["fishball"])
	squidball_tray.tooltip_text = "Squidball: " + str(PlayerData.stock_items["squidball"])
	kikiam_tray.tooltip_text = "Kikiam: " + str(PlayerData.stock_items["kikiam"])
	kwekkwek_tray.tooltip_text = "Kwekkwek: " + str(PlayerData.stock_items["kwekkwek"])
	
	
func update_siomai_steamer():
	if PlayerData.siomai_unlocked:
		$SiomaiSteamer.visible = true
	else:
		$SiomaiSteamer.visible = false
		
	if PlayerData.stock_items["chicken_siomai"] <= 0:
		$SiomaiSteamer/ChickenSiomai.visible = false
	else:
		$SiomaiSteamer/ChickenSiomai.visible = true
	
	if PlayerData.stock_items["pork_siomai"] <= 0:
		$SiomaiSteamer/PorkSiomai.visible = false
	else:
		$SiomaiSteamer/PorkSiomai.visible = true
		
	if PlayerData.stock_items["japanese_siomai"] <= 0:
		$SiomaiSteamer/JapaneseSiomai.visible = false
	else:
		$SiomaiSteamer/JapaneseSiomai.visible = true
		
	$SiomaiSteamer/ChickenSiomaiTooltipPanel.tooltip_text = "Chicken Siomai: " + str(PlayerData.cooked_items["chicken_siomai"])
	$SiomaiSteamer/PorkSiomaiTooltipPanel.tooltip_text = "Pork Siomai: " + str(PlayerData.cooked_items["pork_siomai"])
	$SiomaiSteamer/JapaneseSiomaiTooltipPanel.tooltip_text = "Japanese Siomai: " + str(PlayerData.cooked_items["japanese_siomai"])
	
	
func update_juice_dispenser():
	if PlayerData.juice_unlocked:
		$JuiceDispenser.visible = true
	else:
		$JuiceDispenser.visible = false
		
	if PlayerData.cooked_items["juice"] <= 0:
		$JuiceDispenser/JuiceContainerFull.visible = false
	else:
		$JuiceDispenser/JuiceContainerFull.visible = true
	$JuiceDispenser/TooltipPanel.tooltip_text = "Juice: " + str(PlayerData.cooked_items["juice"])

func start_day():
	daytime_timer.start(300)
	PlayerData.RESET_COOKED_ITEMS_COUNT()
	set_upgrades_cooked_stock_count()
	
func set_upgrades_cooked_stock_count():
	for item in PlayerData.stock_items:
		if item in StreetfoodData.SIOMAI_STREETFOODS or item == "juice":
			PlayerData.UPDATE_COOKED_ITEM(item, PlayerData.stock_items[item])
	
func _on_daytime_timer_timeout() -> void:
	if in_minigame:
		await minigame_has_finished
	end_day()
	
func end_day():
	food_fryer_node.clear_items()
	daytime_timer.stop()
	var new_oil_level: int = randi_range(0, PlayerData.oil_level)
	PlayerData.UPDATE_OIL_LEVEL(new_oil_level)
	PlayerData.UPDATE_UPGRADES()
	emit_signal("day_is_finished")

func is_out_of_stock():
	var out_of_stock: bool = true
	for item in PlayerData.stock_items:
		if PlayerData.stock_items[item] > 0:
			out_of_stock = false
	var out_of_cooked_food: bool = true
	for item in PlayerData.cooked_items:
		if PlayerData.cooked_items[item] > StreetfoodData.REQUIRED_COOKED_FOOD[item]:
			out_of_cooked_food = false
	return out_of_stock and out_of_cooked_food
	
func _on_fishball_pressed() -> void:
	if can_fry_food("fishball"):
		PlayerData.stock_items["fishball"] -= 1
		food_fryer_node.add_streetfood("fishball")


func _on_squidball_pressed() -> void:
	if can_fry_food("squidball"):
		PlayerData.stock_items["squidball"] -= 1
		food_fryer_node.add_streetfood("squidball")


func _on_kikiam_pressed() -> void:
	if can_fry_food("kikiam"):
		PlayerData.stock_items["kikiam"] -= 1
		food_fryer_node.add_streetfood("kikiam")


func _on_kwek_kwek_pressed() -> void:
	if can_fry_food("kwekkwek"):
		PlayerData.stock_items["kwekkwek"] -= 1
		food_fryer_node.add_streetfood("kwekkwek")
		
func can_fry_food(food_name: String):
	return PlayerData.stock_items[food_name] > 0 and food_fryer_node.can_fry(food_name)

func generate_customers():
	var rng = RandomNumberGenerator.new()
	if !customer1 && rng.randi_range(0,1)== 0:
		print("SPAWN C1")
		spawn_customer(1)
	if !customer2 && rng.randi_range(0,1)== 0:
		print("SPAWN C2")
		spawn_customer(2)
	if !customer3 && rng.randi_range(0,1)== 0:
		print("SPAWN C3")
		spawn_customer(3)

func spawn_customer(pos: int):
	var customer_instance: Customer = CUSTOMER_SCENE.instantiate()
	
	var rng = RandomNumberGenerator.new()
	var random_value = rng.randf()
	var type_chance_data = MapData.MAP_CHANCE[location].duplicate()
	type_chance_data.keys().sort_custom(func sort_data(a, b): return type_chance_data[b] - type_chance_data[a])
	
	var total: float
	for type in type_chance_data:
		total += type_chance_data[type]
		if random_value < total:
			customer_instance.character_type = type
			break
			
	#$Customers.add_child(customer_instance)
	customer_instance.connect("start_minigame", _on_start_minigame)
	customer_instance.connect("remove_character", _on_remove_character)
	customer_points[pos - 1].add_child(customer_instance)
	if pos == 1: customer1 = customer_instance
	if pos == 2: customer2 = customer_instance
	if pos == 3: customer3 = customer_instance
	#customer_instance.set_customer_pos(customer1_pos)

func _on_remove_character():
	spawn_interval_timer.start(MapData.MAP_SPAWN_INTERVAL[location])
	
func _on_start_minigame(streetfood_name: String, order: OrderButton):
	minigame_node.start_minigame(streetfood_name, order)
	in_minigame = true
	
func _on_minigame_finished(food_name: String, catched_count: int, catched_spoiled_count: int):
	if catched_count <= 0:
		pass
	elif catched_count / StreetfoodData.REQUIRED_COOKED_FOOD[food_name] > 0.5:
		var tip: int = get_tip(food_name, catched_count)
		if tip > 0:
			emit_signal("received_tip", tip)
			print("RECEIVED TIP: ", tip)
		PlayerData.money += StreetfoodData.STREETFOOD_SELL_PRICE[food_name] + tip
	elif catched_count / StreetfoodData.REQUIRED_COOKED_FOOD[food_name] < 0.5:
		PlayerData.money += StreetfoodData.STREETFOOD_SELL_PRICE[food_name] / 2
	minigame_node.visible = false
	in_minigame = false
	print("CATCHED ITEMS COUNT: ", catched_count)
	print("CATCHED SPOILED ITEMS: ", catched_spoiled_count)
	emit_signal("minigame_has_finished")

func get_tip(food_name: String, catched_count: int):
	var tip_amount: int = 0
	var tip_chance_rand: int = RandomNumberGenerator.new().randi_range(0, 100)
	if tip_chance_rand <= (catched_count / StreetfoodData.REQUIRED_COOKED_FOOD[food_name]) * 100:
		for i in range(RandomNumberGenerator.new().randi_range(0, 10)):
			tip_amount += RandomNumberGenerator.new().randi_range(0, 3)
		
		if catched_count == StreetfoodData.REQUIRED_COOKED_FOOD[food_name]:
			return tip_amount
		else:
			return int(tip_amount * 0.5)
	return 0


func _on_spawn_interval_timer_timeout() -> void:
	can_spawn = true

func _on_end_day_button_pressed() -> void:
	end_day()
