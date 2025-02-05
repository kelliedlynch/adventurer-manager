@tool
extends VBoxContainer
class_name UnitList

@export var list_title: String = "Unit List":
	set(value):
		if value != list_title:
			list_title = value
			if not is_inside_tree():
				await ready
			$ListTitle.text = list_title
			
@onready var list_items: VBoxContainer = $ScrollContainer/ListItems

var action_buttons: Dictionary = {}

var _units: Array[Adventurer] = []:
	set(value):
		_units = value
		_refresh_list()

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and _units.is_empty()):
		for i in 10:
			var adv = Adventurer.new()
			adv.name = "Adventurer " + str(i)
			_units.append(adv)
	_refresh_list()

func _refresh_list() -> void:
	for child in list_items.get_children():
		child.queue_free()
	for unit in _units:
		var new_item = UnitListItem.instantiate()
		new_item.unit = unit
		list_items.add_child(new_item)
		for button in action_buttons:
			new_item.add_action_button("Hire", action_buttons[button].bind(unit))

func register_action_button(text: String, action: Callable):
	action_buttons[text] = action
	_refresh_list()
