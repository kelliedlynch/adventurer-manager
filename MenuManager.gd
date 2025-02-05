extends Node

var _current_menu: int = 0:
	set(value):
		_current_menu = value
		_update_current_menu()
		
var main_control_node: Control

enum {
	MENU_NONE,
	MENU_VIEW_ROSTER,
	MENU_VIEW_TOWN,
	MENU_TAVERN
}

var _menu_file: Dictionary = {
	MENU_VIEW_ROSTER: "res://Interface/RosterInterface/Roster.tscn",
	MENU_VIEW_TOWN: "res://Interface/TownInterface/TownInterface.tscn",
	MENU_TAVERN: "res://Interface/TownInterface/BuildingInterface/TavernInterface.tscn"
}

func open_menu(menu: int):
	if _current_menu == menu:
		return
	else:
		_current_menu = menu
		
func close_menu():
	_current_menu = MENU_NONE

func toggle_menu(menu: int):
	if _current_menu == menu:
		close_menu()
	else:
		open_menu(menu)

func _update_current_menu():
	_close_menu()
	if _current_menu != MENU_NONE:
		var menu = load(_menu_file[_current_menu]).instantiate()
		main_control_node.add_child(menu)
	pass
	
func _close_menu():
	for child in main_control_node.get_children():
		if child is Menu:
			child.queue_free()
			break
