extends RigidBody2D

class_name FryingStreetfood

signal is_cooked(food_name: String)

const FRICTION_CONSTANT: float = 0.9

@onready var uncooked_sprite: Sprite2D = $UncookedSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var velocity: Vector2 = Vector2.ZERO
var random_vel: Vector2 = Vector2.ZERO

var food_fryer_pos: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position += Vector2(randi_range(-50, 50), randi_range(-50, 50))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if food_fryer_pos != Vector2.ZERO:
		if RandomNumberGenerator.new().randi_range(0, 10) == 9:
			random_vel = get_random_velocity()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	apply_force(random_vel)
	apply_force(get_food_fryer_distance_velocity())
	linear_velocity *= FRICTION_CONSTANT

func set_food_item(food_name: String):
	set_texture(food_name)
	set_collision_shape(food_name)
	await get_tree().create_timer(StreetfoodData.STREETFOOD_COOKTIME[food_name]).timeout
	if is_instance_valid(self):
		emit_signal("is_cooked", food_name)
		PlayerData.UPDATE_COOKED_ITEM(food_name, 1)
		queue_free()

func map_range(value, start1, stop1, start2, stop2):
	return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2

func get_food_fryer_distance_velocity():
	var food_fryer_direction: Vector2 = global_position - food_fryer_pos
	return food_fryer_direction.normalized() * -3 * (food_fryer_direction.length() / 80)
	
func get_random_velocity():
	return Vector2(randi_range(-100, 100), randi_range(-100, 100)).normalized() * 40

func set_food_fryer_pos(pos: Vector2):
	food_fryer_pos = pos

func set_texture(food_name: String):
	uncooked_sprite.texture = load("res://assets/streetfoods/raw/" + food_name + ".png")
	
func set_collision_shape(food_name: String):
	if food_name == "kikiam":
		collision_shape.shape = CapsuleShape2D.new()
		collision_shape.shape.height = 40
		collision_shape.rotation_degrees = 70
	elif food_name == "kwekkwek":
		collision_shape.shape.radius = 20
		uncooked_sprite.scale = Vector2(0.2, 0.2)
