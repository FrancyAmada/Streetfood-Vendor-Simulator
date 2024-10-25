extends Node2D

signal event_passed()
signal event_failed()


@onready var text_label: Label = $Label
@onready var button: Button = $Button

var current_event: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play_event("broken_wheel")
	pass

func play_event(event_name: String):
	button.visible = false
	current_event = event_name
	var tween = create_tween()
	text_label.text = Global.EVENTS[event_name].text
	button.text = str(Global.EVENTS[event_name].reward)
	text_label.visible_ratio = 0
	tween.tween_property(text_label, "visible_ratio", 1, 8)
	await get_tree().create_timer(6).timeout
	button.visible = true
	await tween.finished


func _on_button_pressed() -> void:
	if PlayerData.money + Global.EVENTS[current_event].reward >= 0:
		PlayerData.money += Global.EVENTS[current_event].reward
		if current_event == "treatment" and !PlayerData.mission_finished:
			PlayerData.mission_finished = true
		emit_signal("event_passed")
	else:
		emit_signal("event_failed")
