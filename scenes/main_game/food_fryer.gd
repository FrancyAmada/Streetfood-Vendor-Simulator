extends Node2D

class_name FoodFryer


const FRYING_STREETFOOD = preload("res://scenes/main_game/frying_streetfood.tscn")

@onready var main_game: Node2D = get_parent()
@onready var items_node: Node2D = $ItemsNode

var max_cookable_items_count: int = 50

var items_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Test ------------------------------
	#for r in range(5):
		#for i in range(10):
			#await get_tree().create_timer(0.1).timeout
			#add_streetfood("fishball")
		#await get_tree().create_timer(3).timeout
			#
	#await get_tree().create_timer(3).timeout
	#add_streetfood("fishball")
	# -----------------------------------
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_streetfood(streetfood_name: String):
	if items_count + StreetfoodData.STREETFOOD_FRYING_SPACE[streetfood_name] <= max_cookable_items_count:
		items_count += StreetfoodData.STREETFOOD_FRYING_SPACE[streetfood_name]
		var frying_streetfood_instance: FryingStreetfood = FRYING_STREETFOOD.instantiate()
		items_node.add_child(frying_streetfood_instance)
		frying_streetfood_instance.set_food_item(streetfood_name)
		frying_streetfood_instance.set_food_fryer_pos(global_position)
		frying_streetfood_instance.connect("is_cooked", _on_food_is_cooked)

func _on_food_is_cooked(food_name: String):
	items_count -= StreetfoodData.STREETFOOD_FRYING_SPACE[food_name]
