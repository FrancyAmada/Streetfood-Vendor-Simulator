extends Node2D


@onready var main_menu: Node2D = $MainMenu
@onready var intro_scene: Node2D = $IntroScene
@onready var main_game: Node2D = $Game
@onready var event_scene: Node2D = $EventScene
@onready var restock_menu: Node2D = $RestockMenu
@onready var area_selection_menu: AreaSelection = $AreaSelectionMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	main_menu.connect("play_is_pressed", _on_play_is_pressed)
	main_game.connect("day_is_finished", _on_day_is_finished)
	restock_menu.connect("next_is_pressed", _on_next_is_pressed)
	restock_menu.connect("game_is_lost", _on_player_failed)
	AudioManager.play_main_menu_music()
	area_selection_menu.connect("start_day", _on_area_selection_done)
	intro_scene.connect("intro_finished", _on_intro_finished)
	event_scene.connect("event_passed", _on_event_scene_passed)
	event_scene.connect("event_failed", _on_player_failed)

func _on_play_is_pressed():
	animation_player.play("fade_in")	
	await animation_player.animation_finished
	main_menu.visible = false
	if PlayerData.first_play:
		intro_scene.visible = true
		animation_player.play("fade_out")
		await animation_player.animation_finished
		intro_scene.play_intro()
	else:
		main_game.visible = true
		animation_player.play("fade_out")
		await animation_player.animation_finished
		main_game.start_day()
		AudioManager.play_game_music()

func _on_intro_finished():
	animation_player.play("fade_in")	
	await animation_player.animation_finished
	intro_scene.visible = false
	main_game.visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	main_game.start_day()
	AudioManager.play_game_music()

func _on_day_is_finished():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	main_game.visible = false
	var event_rand: int = RandomNumberGenerator.new().randi_range(1, 6)
	var event_choice: int = RandomNumberGenerator.new().randi_range(1, 6)
	if PlayerData.money >= 10000 and !PlayerData.mission_finished:
		event_scene.visible = true
		event_scene.play_event("treatment")
	elif event_rand == event_choice:
		event_scene.visible = true
		var keys = Global.EVENTS.keys()
		keys.erase("treatment")
		event_scene.play_event(keys.pick_random())
	else:
		restock_menu.visible = true
		AudioManager.play_restock_menu_music()
	animation_player.play("fade_out")
	await animation_player.animation_finished

func _on_event_scene_passed():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	event_scene.visible = false
	restock_menu.visible = true
	AudioManager.play_restock_menu_music()
	animation_player.play("fade_out")
	await animation_player.animation_finished

func _on_player_failed():
	get_tree().quit()

func _on_next_is_pressed():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	restock_menu.visible = false
	area_selection_menu.visible = true
	AudioManager.play_area_select_music()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
func _on_area_selection_done():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	area_selection_menu.visible = false
	main_game.visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	main_game.start_day()
	AudioManager.play_game_music()
