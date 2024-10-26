extends Node2D

signal intro_finished()


@onready var text_label: Label = $Label

func _ready() -> void:
	$Button.visible = false
	text_label.text = ""

func play_intro():
	var tween = create_tween()
	text_label.text = Global.INTRO_STORY
	text_label.visible_ratio = 0
	tween.tween_property(text_label, "visible_ratio", 1, 15)
	await get_tree().create_timer(5).timeout
	$Button.visible = true
	await tween.finished
	pass
	
func _on_button_pressed() -> void:
	emit_signal("intro_finished")
	
