extends VBoxContainer

func _ready() -> void:
	MenuManager.main_control_node = $Main
	$ActionBar/HBoxContainer/RosterButton.pressed.connect(_on_roster_button_pressed)
	$ActionBar/HBoxContainer/TownButton.pressed.connect(_on_town_button_pressed)
	
	
func _on_roster_button_pressed():
	MenuManager.toggle_menu(MenuManager.MENU_VIEW_ROSTER)

func _on_town_button_pressed():
	MenuManager.toggle_menu(MenuManager.MENU_TAVERN)
