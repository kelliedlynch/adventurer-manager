@tool
extends Menu
class_name UnitList

@onready var title_label = $VBoxContainer/ListTitle

@export var list_title: String = "Unit List":
	set(value):
		if value != list_title:
			list_title = value
			if not is_inside_tree():
				await ready
			title_label.text = list_title
			
@onready var list_items_container: VBoxContainer = $VBoxContainer/ScrollContainer/ListItems

signal item_clicked

var registered_buttons: Array[Dictionary] = []

var _units: Array[Adventurer] = []:
	set(value):
		_units = value
		_refresh_list()
		
func add_unit(unit: Adventurer):
	_units.append(unit)
	_refresh_list()

func remove_unit(unit: Adventurer):
	var index = _units.find(unit)
	if index != -1:
		_units.remove_at(index)
		_refresh_list()

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and _units.is_empty()):
		for i in 10:
			var adv = Adventurer.new()
			adv.name = "Adventurer " + str(i)
			_units.append(adv)
	_refresh_list()

func _refresh_list() -> void:
	for child in list_items_container.get_children():
		child.queue_free()
	for unit in _units:
		var new_item = UnitListItem.instantiate()
		new_item.unit = unit
		list_items_container.add_child(new_item)
		new_item.item_clicked.connect(item_clicked.emit.bind(unit))
		for button in registered_buttons:
			var butt = new_item.add_action_button(button.text, button.action.bind(unit))
			if not button.active_if.call(unit):
				butt.disabled = true
		_watch_labeled_fields(unit, new_item)

func register_action_button(text: String, action: Callable, active_if: Callable = func(): return true):
	var dict = {
		"text": text,
		"action": action,
		"active_if": active_if
	}
	registered_buttons.append(dict)
	_refresh_list()
