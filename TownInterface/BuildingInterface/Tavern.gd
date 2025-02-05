@tool
extends Menu
class_name Tavern

var adventurers_for_hire: Array[Adventurer] = []

func _ready() -> void:
	for i in 10:
		var adv = Adventurer.new()
		adventurers_for_hire.append(adv)
		$HBoxContainer/UnitList.add_unit(adv)
	for item in $HBoxContainer/UnitList.list_items:
		var hire_btn: Button = item.add_action_button("Hire")
		hire_btn.pressed.connect(_on_hire_button_pressed.bind(item.unit))

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
