extends Node

signal unlock_siomai()
signal unlock_juice()

signal minigame_started()
signal minigame_finished()

const OIL_LEVEL_FRYING_SPACE: Array[int] = [0, 10, 20, 30, 40]

const SIOMAI_UPGRADE_COST: int = 600

const JUICE_UPGRADE_COST: int = 300

func UNLOCK_SIOMAI():
	PlayerData.siomai_unlocked = true
	emit_signal("unlock_siomai")

func UNLOCK_JUICE():
	PlayerData.juice_unlocked = true
	emit_signal("unlock_juice")
