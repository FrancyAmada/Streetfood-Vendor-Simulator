extends Node

#signal mute_state_changed(is_muted)

#music
@onready var main_menu_music: AudioStream = preload("res://assets/sounds/bg-music/main_menu-music.wav")
@onready var level_select_music: AudioStream = preload("res://assets/sounds/bg-music/level_select-music.wav")
@onready var game_music: AudioStream = preload("res://assets/sounds/bg-music/game-music.wav")
@onready var restock_menu_music: AudioStream = preload("res://assets/sounds/bg-music/restock_menu-music.wav")

#ui_sfx
@onready var click_sfx: AudioStream = preload("res://assets/sounds/ui-sfx/click.wav")

#sfx
@onready var cha_ching_sfx: AudioStream = preload("res://assets/sounds/sfx/cha-ching.wav")
@onready var correct_catch_sfx: AudioStream = preload("res://assets/sounds/sfx/correct-catch.wav")
@onready var wrong_catch_sfx: AudioStream = preload("res://assets/sounds/sfx/wrong-catch.wav")
@onready var correct_order_sfx: AudioStream = preload("res://assets/sounds/sfx/correct-order.wav")
@onready var oil_sizzling_sfx: AudioStream = preload("res://assets/sounds/sfx/oil-sizzling.wav")
@onready var fail_sfx: AudioStream = preload("res://assets/sounds/sfx/fail.wav")

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")
var background_music: AudioStreamPlayer
var sfx_players: Dictionary = {}

var is_muted: bool = false
var previous_music_volume: float = 1.0
var previous_sfx_volume: float = 1.0

func _ready():
	background_music = AudioStreamPlayer.new()
	add_child(background_music)
	background_music.bus = "Music"
	background_music.autoplay = false

func play_music(stream: AudioStream):
	background_music.stream = stream
	background_music.play()
	
func stop_music():
	background_music.stop()

func play_sfx(sound: AudioStream):
	if sound:
		var sound_name = sound.resource_path.get_file().get_basename()
		if not sfx_players.has(sound_name):
			var player = AudioStreamPlayer.new()
			add_child(player)
			player.bus = "SFX"
			sfx_players[sound_name] = player
		
		sfx_players[sound_name].stream = sound
		sfx_players[sound_name].play()

func stop_sfx(sound_name: String):
	if sfx_players.has(sound_name):
		sfx_players[sound_name].stop()

func stop_all_sfx():
	for player in sfx_players.values():
		player.stop()

func set_music_volume(volume: float):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(volume))
	if volume == 0:
		is_muted = true
	else:
		is_muted = false

func set_sfx_volume(volume: float):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(volume))
	if volume == 0:
		is_muted = true
	else:
		is_muted = false

func mute_audio():
	is_muted = true
	previous_music_volume = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	previous_sfx_volume = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	set_music_volume(0)
	set_sfx_volume(0)
	
func _on_mute_state_changed(to_muted: bool):
	if to_muted:
		mute_audio()
	else:
		unmute_audio()

func unmute_audio():
	is_muted = false
	set_music_volume(previous_music_volume)
	set_sfx_volume(previous_sfx_volume)

func toggle_mute():
	if is_muted:
		unmute_audio()
	else:
		mute_audio()
	emit_signal("mute_state_changed", is_muted)

func play_main_menu_music():
	play_music(main_menu_music)
	
func play_level_select_music():
	play_music(level_select_music)
	
func play_game_music():
	play_music(game_music)
	
func play_restock_menu_music():
	play_music(restock_menu_music)
	
func play_click_sfx():
	play_sfx(click_sfx)
	
func play_chaching_sfx():
	play_sfx(cha_ching_sfx)
	
func play_correct_catch_sfx():
	play_sfx(correct_catch_sfx)
	
func play_wrong_catch_sfx():
	play_sfx(wrong_catch_sfx)
	
func play_correct_order_sfx():
	play_sfx(correct_order_sfx)
	
func play_oil_sizzling_sfx():
	play_sfx(oil_sizzling_sfx)
	
func play_fail_sfx():
	play_sfx(fail_sfx)
