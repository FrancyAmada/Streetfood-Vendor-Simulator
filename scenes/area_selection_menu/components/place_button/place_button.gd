extends TextureButton

class_name PlaceButton

@export var description: String

@onready var Description: Label = %Description
@onready var Effects: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Description.text = description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Description.visible = is_hovered()
