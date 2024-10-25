extends Label

@export var food_item_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.connect("cooked_item_updated", _on_label_update)

func _on_label_update(food_name: String):
	if food_name == food_item_name:
		text = str(PlayerData.cooked_items[food_name])
