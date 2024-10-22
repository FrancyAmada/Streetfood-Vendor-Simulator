extends Button

@export var description: String

@onready var Description: Label = %Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Description.text = description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_hover()
	
	
func handle_hover() -> void:
	if is_hovered():
		Description.visible = true
	else:
		Description.visible = false
	
