extends Control

@onready var main_control: Control = find_child("Main")
@onready var money_label: LabeledField = find_child("MoneyField")
@onready var roster_button: Button = find_child("RosterButton")
@onready var town_button: Button = find_child("TownButton")
@onready var dungeon_button: Button = find_child("DungeonButton")
@onready var activity_log_button: Button = find_child("ActivityLogButton")
@onready var activity_log_container: Control = find_child("ActivityLogContainer")
@onready var debug_advance_tick: Button = find_child("DebugAdvanceTick")

func _ready() -> void:
	InterfaceManager.main_control_node = $VBoxContainer/Main
	roster_button.pressed.connect(_on_roster_button_pressed)
	town_button.pressed.connect(_on_town_button_pressed)
	dungeon_button.pressed.connect(_on_dungeon_button_pressed)
	activity_log_button.pressed.connect(_toggle_activity_log)
	money_label.watch_object(Player)
	debug_advance_tick.pressed.connect(GameplayEngine.advance_tick)
	
func _toggle_activity_log():
	activity_log_container.visible = !activity_log_container.visible
	
func _on_roster_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is RosterInterface)
	if index != -1:
		InterfaceManager.close_menu(nodes[index])
	else:
		var roster = RosterInterface.instantiate(Player.roster)
		roster.tree_exited.connect(roster_button.set_pressed_no_signal.bind(false))
		InterfaceManager.display_menu(roster, true)

func _on_dungeon_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is DungeonInterface)
	if index != -1:
		InterfaceManager.close_menu(nodes[index])
	else:
		var dungeon = DungeonInterface.instantiate(GameplayEngine.dungeon)
		dungeon.tree_exited.connect(dungeon_button.set_pressed_no_signal.bind(false))
		InterfaceManager.display_menu(dungeon, true)

func _on_town_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is TownInterface)
	if index != -1:
		InterfaceManager.close_menu(nodes[index])
	else:
		var town = TownInterface.instantiate(Player.current_town)
		town.tree_exited.connect(town_button.set_pressed_no_signal.bind(false))
		InterfaceManager.display_menu(town, true)
