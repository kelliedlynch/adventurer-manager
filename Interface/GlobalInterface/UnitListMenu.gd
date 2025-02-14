extends Menu
class_name UnitListMenu

var registered_buttons: Array[Dictionary] = []

var _unit_menuitem_map: Dictionary[Adventurer, UnitListMenuItem] = {}
var units: Array[Adventurer]:
	get:
		return _unit_menuitem_map.keys()
	set(value):
		push_error("can't set units directly; use add/remove functions")

func add_unit(unit: Adventurer):
	if !_unit_menuitem_map.has(unit):
		var item = UnitListMenuItem.instantiate(unit)
		
		_unit_menuitem_map[unit] = item
		
		add_menu_item(item)
		for button in registered_buttons:
			var butt = item.add_action_button(button.text, button.action.bind(unit))
			if not button.active_if.call(unit):
				butt.disabled = true
		

func remove_unit(unit: Adventurer):
	if _unit_menuitem_map.has(unit):
		remove_menu_item(_unit_menuitem_map[unit])
		_unit_menuitem_map.erase(unit)
		

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		for i in 10:
			add_unit(Adventurer.generate_random_newbie())
	#_refresh_queued = true
	super._ready()

func _refresh_menu() -> void:
	for item in _menu_items:
		if !_unit_menuitem_map.has(item.unit):
			remove_menu_item(item)

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

static func instantiate(with_units: Array[Adventurer] = []) -> UnitListMenu:
	var menu = load("res://Interface/RosterInterface/RosterInterface.tscn").instantiate()
	for unit in with_units:
		menu.add_unit(unit)
	return menu
