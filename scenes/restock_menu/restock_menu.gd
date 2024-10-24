extends Node2D

@onready var items = $Items.get_children()
@onready var oil = $Oil
@onready var money_label = $Money/MoneyLabel

@export var money: int = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items.map(func(item): item.connect("buy_item", _on_buy_item))
	oil.connect("refill_oil", _on_refill_oil)
	update_money_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_money_label() -> void:
	money_label.text = str(money)

func _on_buy_item(item: Item) -> void:
	if money < item.price:
		print("NOT ENOUGH MONEY")
		return
	money -= item.price
	item.buy()
	update_money_label()

func _on_refill_oil() -> void:
	if money < oil.price:
		print("NOT ENOUGH MONEY")
		return
	if oil.oil_level >= 100:
		print("MAXIMUM CAPACITY")
		return
	money -= oil.price
	oil.buy()
	update_money_label()
	
func _on_next_button_button_down() -> void:
	print("NEXT")
