extends Node2D

signal play_is_pressed()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: TextureButton = $MainUI/HBoxContainer/Play
@onready var settings_button: TextureButton = $MainUI/HBoxContainer/Settings
@onready var quit_button: TextureButton = $MainUI/HBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("title_idle_animation")


func _on_play_pressed():
	pass


func _on_settings_pressed():
	pass


func _on_exit_pressed():
	get_tree().quit()
