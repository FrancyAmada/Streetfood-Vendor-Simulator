extends Node2D

@onready var cloud_sprites: Array = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	for cloud in cloud_sprites:
		cloud.ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for cloud in cloud_sprites:
		cloud.process(delta)
		if cloud.position.x <= -3000:
			cloud.regenerate()
			
