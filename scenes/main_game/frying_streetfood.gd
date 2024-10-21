extends RigidBody2D

class_name FryingStreetfood

const FRICTION_CONSTANT: float = 0.9

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
	await get_tree().create_timer(20).timeout
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
