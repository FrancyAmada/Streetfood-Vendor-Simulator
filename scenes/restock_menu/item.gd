extends VBoxContainer
class_name Item

signal buy_item(item: Item)

@onready var item_label = $ItemLabel
@onready var price_label = $PriceLabel
@onready var stocks_label = $StocksLabel
@onready var buy_button = $BuyButton

@export var item_name: String = ""
@export var streetfood_name: String = ""
@export var price: int = 0
@export var pack_size: int = 0
@export var locked: bool = false
@export var is_siomai: bool = false

var current_stocks: int = 0

var count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_label.text = item_name
	price_label.text = "Price: " + str(price)
	update_stocks_label()
	Global.connect("unlock_siomai", _on_siomai_unlock)
	Global.connect("unlock_juice", _on_juice_unlock)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	count += 1
	if count >= 5:
		count = 0
		update_stocks_label()

func update_stocks_label() -> void:
	if locked: 
		buy_button.text = "UNLOCK"
	else:
		buy_button.text = "BUY " + "x" + str(pack_size)
	stocks_label.text = "Current Stocks: " + str(PlayerData.stock_items[streetfood_name])

func unlock() -> void:
	locked = false
	buy_button.text = "BUY " + "x" + str(pack_size)

func buy() -> void:
	if !locked:
		PlayerData.stock_items[streetfood_name] += pack_size
		current_stocks += pack_size
		update_stocks_label()

func _on_buy_button_button_down() -> void:
	AudioManager.play_click_sfx()
	emit_signal("buy_item", self)

func _on_siomai_unlock():
	if locked and is_siomai:
		unlock()

func _on_juice_unlock():
	if locked and streetfood_name == "juice":
		unlock()
