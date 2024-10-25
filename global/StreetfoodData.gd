extends Node


const STREETFOOD_COOKTIME: Dictionary = {
	"fishball": 6,
	"kikiam": 8,
	"squidball": 10,
	"kwekkwek": 15,
	"chicken_siomai": 0,
	"pork_siomai": 0,
	"japanese_siomai": 0,
	"juice": 0,
}

const REQUIRED_COOKED_FOOD: Dictionary = {
	"fishball": 5,
	"kikiam": 4,
	"squidball": 4,
	"kwekkwek": 2,
	"chicken_siomai": 3,
	"pork_siomai": 3,
	"japanese_siomai": 3,
	"juice": 1,
}

const STREETFOOD_SELL_PRICE: Dictionary = {
	"fishball": 20,
	"kikiam": 20,
	"squidball": 25,
	"kwekkwek": 25,
	"chicken_siomai": 30,
	"pork_siomai": 35,
	"japanese_siomai": 40,
	"juice": 15,
}

const STREETFOOD_FRYING_SPACE: Dictionary = {
	"fishball": 1,
	"kikiam": 1.5,
	"squidball": 1,
	"kwekkwek": 2,
}

const FRIED_STREETFOODS: Array[String] = ["fishball", "squidball", "kikiam", "kwekkwek"]

const SIOMAI_STREETFOODS: Array[String] = ["chicken_siomai", "pork_siomai", "japanese_siomai"]
