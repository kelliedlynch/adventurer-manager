extends VBoxContainer

var tavern = Tavern.new()

func _ready() -> void:
	MenuManager.main_control_node = $Main
	$ActionBar/HBoxContainer/RosterButton.pressed.connect(_on_roster_button_pressed)
	$ActionBar/HBoxContainer/TownButton.pressed.connect(_on_town_button_pressed)
	
	
func _on_roster_button_pressed():
	var index = $Main.get_children().find_custom(func (x): return x is Roster)
	if index == -1:
		var menu = load("res://Interface/RosterInterface/Roster.tscn").instantiate()
		#menu.model = tavern
		$Main.add_child(menu)
	else:
		$Main.get_child(index).queue_free()

func _on_town_button_pressed():
	var index = $Main.get_children().find_custom(func (x): return x is TavernInterface)
	if index == -1:
		var menu = load("res://Interface/TownInterface/BuildingInterface/TavernInterface.tscn").instantiate()
		menu.model = tavern
		$Main.add_child(menu)
	else:
		$Main.get_child(index).queue_free()
	#MenuManager.toggle_menu(MenuManager.MENU_TAVERN)
