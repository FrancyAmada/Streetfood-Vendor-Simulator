extends Node2D

class_name JuiceDroplet

const DROP_SPEED: int = 1200


func _physics_process(delta: float) -> void:
	global_position.y += DROP_SPEED * delta
	
func set_droplet_position(pos: Vector2):
	global_position = pos
