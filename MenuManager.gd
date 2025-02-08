extends Node

var main_control_node: Control

func display_menu(menu: Menu, replace: bool = false):
	if replace:
		close_all()
	main_control_node.add_child(menu)
	
func close_menu(menu: Menu):
	menu.queue_free()
	
func close_all():
	for child in main_control_node.get_children():
		if child is Menu:
			child.queue_free()
