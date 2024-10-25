extends Node2D

@onready var main_game: Node2D = $Game
@onready var main_menu: Node2D = $MainMenu
@onready var restock_menu: Node2D = $RestockMenu
@onready var area_selection_menu: AreaSelection = $AreaSelectionMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	main_menu.connect("play_is_pressed", _on_play_is_pressed)
	main_game.connect("day_is_finished", _on_day_is_finished)
	restock_menu.connect("next_is_pressed", _on_next_is_pressed)
	AudioManager.play_main_menu_music()
	area_selection_menu.connect("start_day", _on_area_selection_done)

func _on_play_is_pressed():
	animation_player.play("fade_in")	
	await animation_player.animation_finished
	main_menu.visible = false
	main_game.visible = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	main_game.start_day()
	AudioManager.play_game_music()

func _on_day_is_finished():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	main_game.visible = false
	restock_menu.visible = true
	AudioManager.play_restock_menu_music()
	animation_player.play("fade_out")
	await animation_player.animation_finished

func _on_next_is_pressed():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	restock_menu.visible = false
	area_selection_menu.visible = true
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
