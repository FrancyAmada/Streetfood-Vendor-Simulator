extends Node

signal cooked_item_updated(food_name: String)
signal oil_level_updated(level: int)

var first_play: bool = true
var mission_finished: bool = false

var money: int = 9999

var reputation: int = 50

var oil_level: int = 2

var siomai_unlocked = false
var juice_unlocked = false

const COOKED_ITEMS_DEFAULT: Dictionary = {
	"fishball": 0,
	"kikiam": 0,
	"squidball": 0,
	"kwekkwek": 0,
	"chicken_siomai": 0,
	"pork_siomai": 0,
	"japanese_siomai": 0,
	"juice": 0,
}

var cooked_items: Dictionary = {
	"fishball": 0,
	"kikiam": 0,
	"squidball": 0,
	"kwekkwek": 0,
	"chicken_siomai": 0,
	"pork_siomai": 0,
	"japanese_siomai": 0,
	"juice": 0,
}

var stock_items: Dictionary = {
	"fishball": 10,
	"kikiam": 10,
	"squidball": 10,
	"kwekkwek": 10,
	"chicken_siomai": 0,
	"pork_siomai": 0,
	"japanese_siomai": 0,
	"juice": 0,
}
 
func UPDATE_COOKED_ITEM(food_name: String, amount):
	cooked_items[food_name] += amount
	emit_signal("cooked_item_updated", food_name)
	
func UPDATE_OIL_LEVEL(level: int):
	oil_level = level
	emit_signal("oil_level_updated", oil_level)

func RESET_COOKED_ITEMS_COUNT():
	for item in cooked_items:
		UPDATE_COOKED_ITEM(item, -cooked_items[item])
	for siomai in StreetfoodData.SIOMAI_STREETFOODS:
		UPDATE_COOKED_ITEM(siomai, -cooked_items[siomai])
	UPDATE_COOKED_ITEM("juice", -cooked_items["juice"])

func UPDATE_UPGRADES():
	for siomai in StreetfoodData.SIOMAI_STREETFOODS:
		stock_items[siomai] = cooked_items[siomai]
	stock_items["juice"] = cooked_items["juice"]
