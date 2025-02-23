extends Node

var main_control_node: Control
var interface_stack: Array[Reactive] = []

func display_interface(interface: Reactive, replace: bool = false):
	if replace:
		close_all()
	main_control_node.add_child(interface)
	interface_stack.append(interface)
	
func close_interface(interface: Reactive):
	var index = interface_stack.find(interface)
	if index != -1:
		for i in interface_stack.size() - index:
			_close_top_interface()
	
func _close_top_interface():
	var top = interface_stack.back()
	if top:
		top.queue_free()
		interface_stack.erase(top)
	
func close_all():
	while not interface_stack.is_empty():
		_close_top_interface()

func _input(event: InputEvent) -> void:
	if not interface_stack.is_empty() and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_close_top_interface()
