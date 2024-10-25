extends Node2D

signal back_to_menu_pressed

@onready var back_button: TextureButton = $BackButton
@onready var music_slider: Slider = $"VBoxContainer/Music_Volume-Slider"
@onready var sfx_slider: Slider = $"VBoxContainer/SFX_Volume-Slider"
@onready var mute_button: TextureButton = $MuteButton

func _ready():
	await get_tree().create_timer(1).timeout
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.sfx_bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.music_bus))
	update_mute_button_texture()

func _on_back_button_pressed():
	AudioManager.play_click_sfx()
	emit_signal("back_to_menu_pressed")
	
func _on_mute_button_pressed():
	AudioManager.play_click_sfx()
	AudioManager.toggle_mute()
	update_mute_button_texture()
	update_slider_values()

func update_slider_values():
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.sfx_bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.music_bus))
	
func _on_mute_state_changed(_new_mute_state):
	update_mute_button_texture()
	update_slider_values()

func update_mute_button_texture():
	if AudioManager.is_muted:
		mute_button.texture_normal = preload("res://assets/menu/settings/mute_button-pressed.png")
	else:
		mute_button.texture_normal = preload("res://assets/menu/settings/mute_button-unpressed.png")
	
func _on_music_volume_slider_value_changed(value):
	AudioManager.set_music_volume(value)

func _on_sfx_volume_slider_value_changed(value):
	AudioManager.set_sfx_volume(value)
	AudioManager.play_click_sfx()
