extends Node2D

class_name DroppingStreetfood

@onready var streetfood_area: Area2D = $StreetfoodArea
@onready var streetfood_sprite: Sprite2D = $StreetfoodSprite

var dropping: bool = false
var catched: bool = false

var streetfood_area_size: int = 50
var streetfood_drop_speed: int = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(640, -100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dropping and !catched:
		global_position.y += streetfood_drop_speed * delta
		#print_debug(global_position)
	
func set_x_position(x_pos: int):
	global_position.x = x_pos
	
func start_drop():
	dropping = true
	
func catch_streetfood(stick_node: Node2D):
	set_physics_process(false)
	catched = true
	dropping = false
	streetfood_area.set_deferred('monitoring', false)
	get_parent().remove_child(self)
	stick_node.items_node.add_child(self)
	global_position.x = stick_node.global_position.x
	position.y = stick_node.initial_catched_position.y - (stick_node.current_catched_index * streetfood_area_size * 2) - 10
