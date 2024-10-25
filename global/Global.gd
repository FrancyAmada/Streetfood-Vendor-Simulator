extends Node

signal unlock_siomai()

signal minigame_started()
signal minigame_finished()

const OIL_LEVEL_FRYING_SPACE: Array[int] = [0, 20, 30, 40, 50]


func UNLOCK_SIOMAI():
	PlayerData.siomai_unlocked = true
	emit_signal("unlock_siomai")
