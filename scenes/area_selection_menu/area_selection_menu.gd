extends Node2D

class_name AreaSelection

#signal street_is_pressed()
#signal school_is_pressed()
#signal mall_is_pressed()
signal start_day()

var selected_area: String = ""

@onready var mall = $Mall

@onready var start_day_button: Button = $StartDayButton
@onready var selected_area_label: Label = $SelectedAreaLabel

func _ready() -> void:
	mall.disabled = true

func _process(delta: float) -> void:
	if selected_area != "":
		start_day_button.visible = true
	else:
		start_day_button.visible = false

func reset():
	update_selected_area("None")

func _on_street_pressed() -> void:
	update_selected_area("street")
	
func _on_school_pressed() -> void:
	update_selected_area("school")

func _on_mall_pressed() -> void:
	update_selected_area("mall")
	
func update_selected_area(area: String):
	selected_area = area
	selected_area_label.text = "Selected Area: " + selected_area.capitalize()

func _on_buy_permit_pressed() -> void:
	if PlayerData.money >= Global.MALL_PERMIT_COST:
		PlayerData.money -= Global.MALL_PERMIT_COST
		unlock_mall() # instant unlock for now
	
func unlock_mall():
	mall.get_child(1).visible = false
	mall.disabled = false
	
func _on_start_day_button_pressed() -> void:
	emit_signal("start_day")
