extends VBoxContainer
class_name Item

signal buy_item(item: Item)

@onready var item_label = $ItemLabel
@onready var price_label = $PriceLabel
@onready var stocks_label = $StocksLabel
@onready var buy_button = $BuyButton

@export var item_name: String = ""
@export var price: int = 0
@export var pack_size: int = 0
@export var locked: bool = false

var current_stocks: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_label.text = item_name
	price_label.text = str(price)
	update_stocks_label()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_stocks_label() -> void:
	if locked: 
		buy_button.text = "UNLOCK"
	stocks_label.text = "Current Stocks: " + str(current_stocks)

func unlock() -> void:
	locked = false
	buy_button.text = "BUY"

func buy() -> void:
	if locked:
		unlock()
	else:
		current_stocks += pack_size
		update_stocks_label()

func _on_buy_button_button_down() -> void:
	emit_signal("buy_item", self)
