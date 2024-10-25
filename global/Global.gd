extends Node

signal unlock_siomai()

signal minigame_started()
signal minigame_finished()


func UNLOCK_SIOMAI():
	emit_signal("unlock_siomai")
