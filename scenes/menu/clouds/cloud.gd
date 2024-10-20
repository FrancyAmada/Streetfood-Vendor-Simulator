extends Sprite2D

class_name Cloud

var speed: float
var y_displacement: int

# Called when the node enters the scene tree for the first time.
func ready():
	position.y = RandomNumberGenerator.new().randi_range(20, 300)
	position.x = RandomNumberGenerator.new().randi_range(-1800, 1400)
	var new_scale = RandomNumberGenerator.new().randi_range(0.5, 2)
	scale = Vector2(new_scale, new_scale)
	speed = RandomNumberGenerator.new().randi_range(100, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	position.x -= speed * delta
	var move_y = randi_range(0, 10)
	if move_y > 8:
		y_displacement = RandomNumberGenerator.new().randi_range(-100, 100)
		position.y -= y_displacement * delta
	if move_y <= 5 and move_y > 3:
		position.y -= y_displacement * delta

func regenerate():
	texture = load("res://assets/others/clouds/cloud_"+str(RandomNumberGenerator.new().randi_range(1, 6))+".png")
	position.y = RandomNumberGenerator.new().randi_range(20, 300)
	position.x = RandomNumberGenerator.new().randi_range(1500, 2000)
	var new_scale = RandomNumberGenerator.new().randi_range(0.5, 2)
	scale = Vector2(new_scale, new_scale)
	speed = RandomNumberGenerator.new().randi_range(100, 200)
