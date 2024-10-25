extends Node2D

signal play_is_pressed()

@onready var settings = $Settings
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: TextureButton = $MainUI/HBoxContainer/Play
@onready var settings_button: TextureButton = $MainUI/HBoxContainer/Settings
@onready var quit_button: TextureButton = $MainUI/HBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("title_idle_animation")
	settings.connect("back_to_menu_pressed", _on_settings_back_pressed)

func _on_play_pressed():
	emit_signal("play_is_pressed")
	AudioManager.play_click_sfx()

func _on_settings_pressed():
	animation_player.play("settings_pressed")
	AudioManager.play_click_sfx()

func _on_settings_back_pressed():
	AudioManager.play_click_sfx()
	animation_player.play("exit_settings_pressed")
	await animation_player.animation_finished

func _on_exit_pressed():
	get_tree().quit()
