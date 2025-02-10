@tool
extends Menu
class_name UnitListMenu

var registered_buttons: Array[Dictionary] = []

var _units: Dictionary[Adventurer, UnitListMenuItem] = {}
var units: Array[Adventurer]:
	get:
		return _units.keys()
	set(value):
		push_error("can't set units directly; use add/remove functions")

func add_unit(unit: Adventurer):
	if !_units.has(unit):
		var item = UnitListMenuItem.instantiate(unit)
		_units[unit] = item
		add_menu_item(item)

func remove_unit(unit: Adventurer):
	if _units.has(unit):
		remove_menu_item(_units[unit])
		_units.erase(unit)

func _ready() -> void:
	if get_tree().current_scene == self or (Engine.is_editor_hint() and units.is_empty()):
		for i in 10:
			add_unit(Adventurer.new())
	#_refresh_queued = true
	super._ready()

func _refresh_menu() -> void:
	clear_menu_items()
	for unit in units:
		var item = UnitListMenuItem.instantiate(unit)
		_units[unit] = item
		add_menu_item(item)
		#new_item.item_clicked.connect(item_clicked.emit)
		for button in registered_buttons:
			var butt = item.add_action_button(button.text, button.action.bind(unit))
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

static func instantiate(units: Array[Adventurer] = []) -> UnitListMenu:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	for unit in units:
		menu.add_unit(unit)
	return menu
