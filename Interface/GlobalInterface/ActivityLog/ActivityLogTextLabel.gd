extends Label
class_name ActivityLogTextLabel

var outlined: bool = false:
	set(value):
		outlined = value
		if value == true:
			theme_type_variation = "HighlightedLabel"
		else:
			theme_type_variation = ""

signal clicked

func _init(msg: ActivityLogMessage):
	text = msg.text
	clicked.connect(_on_clicked.bind(msg.menu))
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(set.bind("outlined", true))
	mouse_exited.connect(set.bind("outlined", false))
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	custom_minimum_size = Vector2(100, 0)

	
func _on_clicked(constructor: Callable):
	var menu = constructor.call()
	InterfaceManager.display_interface(menu, true)

func _gui_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		clicked.emit()
