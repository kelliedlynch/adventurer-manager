extends Control

@onready var main_control: Control = $VBoxContainer/Main
@onready var money_label: LabeledField = $VBoxContainer/ActionBar/HBoxContainer/MoneyLabel
@onready var roster_button: Button = $VBoxContainer/ActionBar/HBoxContainer/RosterButton
@onready var town_button: Button = $VBoxContainer/ActionBar/HBoxContainer/TownButton
@onready var dungeon_button: Button = $VBoxContainer/ActionBar/HBoxContainer/DungeonButton
@onready var activity_log_button: Button = $VBoxContainer/ActionBar/HBoxContainer/ActivityLogButton
@onready var activity_log_container: Control = $ActivityLogContainer

func _ready() -> void:
	MenuManager.main_control_node = $VBoxContainer/Main
	roster_button.pressed.connect(_on_roster_button_pressed)
	town_button.pressed.connect(_on_town_button_pressed)
	dungeon_button.pressed.connect(_on_dungeon_button_pressed)
	activity_log_button.pressed.connect(_toggle_notification_window)
	money_label.watch_object(Player)
	$DebugAdvanceTick.pressed.connect(GameplayEngine.advance_tick)
	
func _toggle_notification_window():
	activity_log_container.visible = !activity_log_container.visible
	
func _on_roster_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is RosterInterface)
	if index != -1:
		MenuManager.close_menu(nodes[index])
	else:
		var roster = RosterInterface.instantiate(Player.roster)
		roster.tree_exited.connect(roster_button.set_pressed_no_signal.bind(false))
		MenuManager.display_menu(roster, true)

func _on_dungeon_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is DungeonInterface)
	if index != -1:
		MenuManager.close_menu(nodes[index])
	else:
		var dungeon = DungeonInterface.instantiate(GameplayEngine.dungeon)
		dungeon.tree_exited.connect(dungeon_button.set_pressed_no_signal.bind(false))
		MenuManager.display_menu(dungeon, true)

func _on_town_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is TownInterface)
	if index != -1:
		MenuManager.close_menu(nodes[index])
	else:
		var town = TownInterface.instantiate(GameplayEngine.town)
		town.tree_exited.connect(town_button.set_pressed_no_signal.bind(false))
		MenuManager.display_menu(town, true)
