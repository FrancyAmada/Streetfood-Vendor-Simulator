extends Node2D


@onready var items_node: Node2D = $ItemsNode

var initial_catched_position: Vector2 = Vector2(0, 300)
var current_catched_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_stick(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	global_position.x = get_global_mouse_position().x
	if global_position.x < 20: global_position.x = 20
	if global_position.x > 1260: global_position.x = 1260

func activate_stick(to_on: bool):
	set_physics_process(to_on)

func move_to_center():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(640, 300), 1)

func _on_stick_head_area_area_entered(area: Area2D) -> void:
	if area.get_parent():
		var streetfood_item: DroppingStreetfood = area.get_parent()
		if !streetfood_item.catched:
			streetfood_item.catch_streetfood(self)
			current_catched_index += 1
			print("CATCHED ITEM!")
