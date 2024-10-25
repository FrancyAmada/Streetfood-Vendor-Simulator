extends Node2D

class_name DroppingStreetfood

@onready var streetfood_area: Area2D = $StreetfoodArea
@onready var streetfood_sprite: Sprite2D = $StreetfoodSprite

var dropping: bool = false
var catched: bool = false

var is_spoiled: bool = false

var streetfood_area_size: int = 50
var streetfood_drop_speed: int = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2(640, -200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dropping and !catched:
		global_position.y += streetfood_drop_speed * delta
		#print_debug(global_position)
		if global_position.y >= 1000:
			queue_free()
	
func set_x_position(x_pos: int):
	global_position.x = x_pos
	
func set_streetfood(food_name: String, spoiled: bool):
	is_spoiled = spoiled
	set_streetfood_texture(food_name)
	update_streetfood_scale(food_name)

func update_streetfood_scale(food_name):
	if food_name == "kwekkwek":
		streetfood_sprite.scale = Vector2(1, 1)
		$StreetfoodArea/CollisionShape2D.shape.radius = 100
		streetfood_drop_speed = 1200
		streetfood_area_size = 100
	
func set_streetfood_texture(food_name: String):
	if is_spoiled:
		streetfood_sprite.texture = load("res://assets/streetfoods/spoiled/" + food_name + ".png")
	else:
		streetfood_sprite.texture = load("res://assets/streetfoods/cooked/" + food_name + ".png")
	
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

func _on_streetfood_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is DroppingStreetfood:
		var collided_item = area.get_parent()
		var direction: Vector2 = global_position.direction_to(collided_item.global_position).normalized()
		global_position.x += -direction.x * streetfood_area_size
