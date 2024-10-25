extends Node

signal unlock_siomai()

signal minigame_started()
signal minigame_finished()

const OIL_LEVEL_FRYING_SPACE: Array[int] = [0, 10, 20, 30, 40]


func UNLOCK_SIOMAI():
	PlayerData.siomai_unlocked = true
	emit_signal("unlock_siomai")
