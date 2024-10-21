extends Button

class_name OrderButton

signal start_minigame(streetfood_name: String)

var streetfood_name: String = ''


func _on_pressed() -> void:
	emit_signal("start_minigame", streetfood_name)

func set_streetfood(order_name: String):
	streetfood_name = order_name
