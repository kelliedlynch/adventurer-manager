@tool
extends Menu
class_name TavernInterface

@onready var unit_list: UnitList = $HBoxContainer/UnitList


var model: Tavern:
	set(value):
		model = value
		unit_list._units = value.adventurers_for_hire
		#unit_list._refresh_list()
		value.adventurers_for_hire_changed.connect(unit_list._refresh_list)

func _ready() -> void:
	if model == null:
		model = Tavern.new()
	#for adventurer in model.adventurers_for_hire:
		#$HBoxContainer/UnitList.add_unit(adventurer)
	#for item in $HBoxContainer/UnitList.list_items:
		#var hire_btn: Button = item.add_action_button("Hire")
		#hire_btn.pressed.connect(_on_hire_button_pressed.bind(item.unit))

func _on_hire_button_pressed(unit: Adventurer):
	$HireConfirmDialog.visible = true
	$HireConfirmDialog/VBoxContainer/HBoxContainer/Yes.pressed.connect(_confirm_hire.bind(unit))
	$HireConfirmDialog/VBoxContainer/HBoxContainer/No.pressed.connect(_cancel_hire)
	
func _confirm_hire(unit: Adventurer):
	Player.roster.append(unit)
	$HBoxContainer/UnitList.remove_unit(unit)
	$HireConfirmDialog.visible = false

func _cancel_hire():
	$HireConfirmDialog/VBoxContainer/HBoxContainer/Yes.pressed.disconnect(_confirm_hire)
	$HireConfirmDialog.visible = false
