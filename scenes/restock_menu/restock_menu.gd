extends Node2D

signal game_is_lost()
signal next_is_pressed()

@onready var items = $Items.get_children()
@onready var oil = $Oil
@onready var money_label = $Money/MoneyLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items.map(func(item): item.connect("buy_item", _on_buy_item))
	oil.connect("refill_oil", _on_refill_oil)
	update_money_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_money_label()

func update_money_label() -> void:
	money_label.text = str(PlayerData.money)

func _on_buy_item(item: Item) -> void:
	if PlayerData.money < item.price:
		print("NOT ENOUGH MONEY")
		return
	PlayerData.money -= item.price
	item.buy()

func _on_refill_oil() -> void:
	if PlayerData.money < oil.price:
		print("NOT ENOUGH MONEY")
		return
	if oil.oil_level >= 100 or PlayerData.oil_level >= 4:
		print("MAXIMUM CAPACITY")
		return
	PlayerData.money -= oil.price
	oil.buy()
	
	
func _on_next_button_button_down() -> void:
	if PlayerData.oil_level <= 0:
		if PlayerData.money < oil.price:
			emit_signal("game_is_lost")
		print("BUY MORE OIL")
		return
	print("NEXT")
	emit_signal("next_is_pressed")

func _on_unlock_siomai_pressed() -> void:
	if PlayerData.money >= Global.SIOMAI_UPGRADE_COST:
		PlayerData.money -= Global.SIOMAI_UPGRADE_COST
		Global.UNLOCK_SIOMAI()
		$UnlockSiomai.disabled = true
		$UnlockSiomai.visible = false

func _on_unlock_juice_pressed() -> void:
	if PlayerData.money >= Global.JUICE_UPGRADE_COST:
		PlayerData.money -= Global.JUICE_UPGRADE_COST
		Global.UNLOCK_JUICE()
		$UnlockJuice.disabled = true
		$UnlockJuice.visible = false
