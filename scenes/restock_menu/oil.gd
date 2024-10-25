extends VBoxContainer

signal refill_oil

@onready var price_label = $PriceLabel
@onready var oil_bar = $OilBar
@onready var oil_button = $OilButton

@export var price: int = 0

var oil_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price_label.text = "Price: " + str(price)
	update_oil_bar()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_oil_level()

func update_oil_level():
	oil_level = PlayerData.oil_level * 25
	update_oil_bar()

func update_oil_bar() -> void:
	oil_bar.value = oil_level

func buy() -> void:
	PlayerData.UPDATE_OIL_LEVEL(PlayerData.oil_level+1)
	update_oil_bar()

func _on_oil_button_button_down() -> void:
	emit_signal("refill_oil")
