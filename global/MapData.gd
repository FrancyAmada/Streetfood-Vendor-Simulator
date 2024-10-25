extends Node


const MAP_SPAWN_RATE: Dictionary = {
	"street" : 0.3,
	"school" : 0.5,
	"mall" : 0.2,
}

const MAP_CHANCE: Dictionary = {
	"street" : {"student" : 0.15, "normal" : 0.80, "rich" : 0.05,},
	"school": {"student" : 0.80, "normal" : 0.05, "rich" : 0.15,},
	"mall": {"student" : 0.05, "normal" : 0.15, "rich" : 0.80,},
}
