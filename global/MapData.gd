extends Node


const MAP_SPAWN_INTERVAL: Dictionary = {
	"street" : 25,
	"school" : 15,
	"mall" : 35,
}

const MAP_CHANCE: Dictionary = {
	"street" : {"student" : 0.15, "normal" : 0.80, "rich" : 0.05,},
	"school": {"student" : 0.80, "normal" : 0.05, "rich" : 0.15,},
	"mall": {"student" : 0.05, "normal" : 0.15, "rich" : 0.80,},
}
