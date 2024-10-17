extends Node2D

signal play_is_pressed()

@onready var play_button: TextureButton = $MainUI/HBoxContainer/Play
@onready var settings_button: TextureButton = $MainUI/HBoxContainer/Settings
@onready var quit_button: TextureButton = $MainUI/HBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_play_pressed():
	emit_signal("play_is_pressed")


func _on_settings_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
