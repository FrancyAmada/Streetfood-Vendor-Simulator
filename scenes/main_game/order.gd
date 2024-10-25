extends Button

class_name OrderButton

signal start_minigame(streetfood_name: String, order: OrderButton)

var streetfood_name: String = ''

func _ready() -> void:
	Global.connect("minigame_started", _on_minigame_started)
	Global.connect("minigame_finished", _on_minigame_finished)

func _on_pressed() -> void:
	AudioManager.play_click_sfx()
	if PlayerData.cooked_items[streetfood_name] >= StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name]:
		PlayerData.UPDATE_COOKED_ITEM(streetfood_name, -StreetfoodData.REQUIRED_COOKED_FOOD[streetfood_name])
		emit_signal("start_minigame", streetfood_name, self)

func set_streetfood(order_name: String):
	streetfood_name = order_name
	#text = streetfood_name.capitalize()
	var order_icon = load('res://assets/customer_orders/' + order_name + '.png')
	icon = order_icon

func _on_minigame_started():
	disabled = true
	
func _on_minigame_finished():
	await get_tree().create_timer(1).timeout
	disabled = false
