extends Node2D

class_name AreaSelection

signal street_is_pressed()
signal school_is_pressed()
signal mall_is_pressed()

@onready var mall = $Mall

func _ready() -> void:
	mall.disabled = true

func _on_street_pressed() -> void:
	emit_signal("street_is_pressed")
	

func _on_school_pressed() -> void:
	emit_signal("school_is_pressed")


func _on_mall_pressed() -> void:
	emit_signal("mall_is_pressed")


func _on_buy_permit_pressed() -> void:
	unlock_mall()
	

func unlock_mall():
	mall.get_child(1).visible = false
	mall.disabled = false
	
