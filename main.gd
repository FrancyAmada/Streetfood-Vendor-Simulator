extends Node2D

@onready var main_game: Node2D = $Game
@onready var main_menu: Node2D = $MainMenu
@onready var restock_menu: Node2D = $RestockMenu


func _ready() -> void:
	main_menu.connect("play_is_pressed", _on_play_is_pressed)
	main_game.connect("day_is_finished", _on_day_is_finished)
	restock_menu.connect("next_is_pressed", _on_next_is_pressed)
	AudioManager.play_main_menu_music()

func _on_play_is_pressed():
	main_menu.visible = false
	main_game.visible = true
	main_game.start_day()
	AudioManager.play_game_music()

func _on_day_is_finished():
	main_game.visible = false
	restock_menu.visible = true
	AudioManager.play_restock_menu_music()

func _on_next_is_pressed():
	restock_menu.visible = false
	main_game.visible = true
	main_game.start_day()
	AudioManager.play_game_music()
