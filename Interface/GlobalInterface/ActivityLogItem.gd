extends Label
class_name ActivityLogItem

var outlined: bool = false

signal clicked

func _init(msg: ActivityLogMessage):
	text = msg.text
	clicked.connect(_on_clicked.bind(msg.menu))
	mouse_entered.connect(set.bind("outlined", true))
	mouse_exited.connect(set.bind("outlined", false))
	
func _on_clicked(menu_type: Variant):
	var menu = menu_type.instantiate()
	MenuManager.display_menu(menu, true)

func _gui_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		clicked.emit()
