@tool
extends Menu
class_name UnitList

@onready var title_container: PanelContainer = $VBoxContainer/PanelContainer
@onready var title_label: Label = $VBoxContainer/PanelContainer/ListTitle

@export var list_title: String = "Unit List":
	set(value):
		if value != list_title:
			list_title = value
			if not is_inside_tree():
				await ready
			title_label.text = list_title
			title_container.visible = value != ""
			
@onready var list_items_container: VBoxContainer = $VBoxContainer/ScrollContainer/ListItems

signal item_clicked


var registered_buttons: Array[Dictionary] = []

var _units: Array[Adventurer] = []:
	set(value):
		_units = value
		_refresh_queued = true
var units: Array[Adventurer]:
	get:
		return _units.duplicate()
	set(value):
		push_error("can't set units directly; use add/remove functions")

func add_unit(unit: Adventurer):
	_units.append(unit)
	_refresh_queued = true

func remove_unit(unit: Adventurer):
	var index = _units.find(unit)
	if index != -1:
		_units.remove_at(index)
		_refresh_queued = true

func clear_units():
	_units.clear()

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and _units.is_empty()):
		for i in 10:
			var adv = Adventurer.new()
			adv.name = "Adventurer " + str(i)
			_units.append(adv)
	_refresh_queued = true
	super._ready()

func _refresh_menu() -> void:
	for child in list_items_container.get_children():
		child.queue_free()
	for unit in _units:
		var new_item = UnitListItem.instantiate()
		new_item.unit = unit
		list_items_container.add_child(new_item)
		new_item.item_clicked.connect(item_clicked.emit)
		for button in registered_buttons:
			var butt = new_item.add_action_button(button.text, button.action.bind(unit))
			if not button.active_if.call(unit):
				butt.disabled = true
		#new_item._watch_labeled_fields()
		#_watch_labeled_fields(unit, new_item)

func register_action_button(text: String, action: Callable, active_if: Callable = func(): return true):
	var dict = {
		"text": text,
		"action": action,
		"active_if": active_if
	}
	registered_buttons.append(dict)
	_refresh_queued = true

func _on_is_submenu_changed(val: bool):
	title_label.theme_type_variation = "TitleSmall" if val == true else "TitleBig"
