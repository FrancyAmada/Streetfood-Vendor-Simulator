extends Node2D

class_name AreaSelection

signal street_is_pressed()
signal school_is_pressed()
signal mall_is_pressed()

func _on_street_pressed() -> void:
	emit_signal("street_is_pressed")
	

func _on_school_pressed() -> void:
	emit_signal("school_is_pressed")


func _on_mall_pressed() -> void:
	emit_signal("mall_is_pressed")
