extends VBoxContainer

@onready var main_control: Control = $Main
@onready var money_label: LabeledField = $ActionBar/HBoxContainer/MoneyLabel
@onready var roster_button: Button = $ActionBar/HBoxContainer/RosterButton
@onready var town_button: Button = $ActionBar/HBoxContainer/TownButton
@onready var dungeon_button: Button = $ActionBar/HBoxContainer/DungeonButton

func _ready() -> void:
	#MenuManager.main_control_node = $Main
	roster_button.pressed.connect(_on_roster_button_pressed)
	town_button.pressed.connect(_on_town_button_pressed)
	dungeon_button.pressed.connect(_on_dungeon_button_pressed)
	money_label.watch_object(Player)
	
func _on_roster_button_pressed():
	var index = main_control.get_children().find_custom(func (x): return x is Roster)
	_close_current_menu()
	if index == -1:
		var menu = Roster.instantiate()
		main_control.add_child(menu)


func _on_dungeon_button_pressed():
	var index = main_control.get_children().find_custom(func (x): return x is DungeonInterface)
	_close_current_menu()
	if index == -1:
		var dungeon = DungeonInterface.instantiate()
		dungeon.model = Dungeon.new()
		main_control.add_child(dungeon)


func _on_town_button_pressed():
	var index = main_control.get_children().find_custom(func (x): return x is TownInterface)
	_close_current_menu()
	if index == -1:
		var menu = TownInterface.instantiate()
		menu.model = Player.current_town
		main_control.add_child(menu)

		
func _close_current_menu():
	for child in main_control.get_children():
		child.queue_free()
