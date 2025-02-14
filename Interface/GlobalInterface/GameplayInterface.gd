extends Control

@onready var main_control: Control = find_child("Main")
@onready var money_label: ReactiveField = find_child("MoneyField")
@onready var roster_button: Button = find_child("RosterButton")
@onready var inventory_button: Button = find_child("InventoryButton")
@onready var town_button: Button = find_child("TownButton")
@onready var dungeon_button: Button = find_child("DungeonButton")
@onready var activity_log_button: Button = find_child("ActivityLogButton")
@onready var activity_log: ActivityLogInterface = find_child("ActivityLog")
@onready var debug_advance_tick: Button = find_child("DebugAdvanceTick")

func _ready() -> void:
	InterfaceManager.main_control_node = $VBoxContainer/Main
	roster_button.pressed.connect(_on_roster_button_pressed)
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	town_button.pressed.connect(_on_town_button_pressed)
	dungeon_button.pressed.connect(_on_dungeon_button_pressed)
	activity_log_button.pressed.connect(activity_log.toggle_window)
	money_label.watch_object(Player)
	debug_advance_tick.pressed.connect(GameplayEngine.advance_tick)
	

	
func _on_roster_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is RosterInterface)
	if index != -1:
		InterfaceManager.close_menu(nodes[index])
	else:
		var roster = RosterInterface.instantiate()
		roster.tree_exited.connect(roster_button.set_pressed_no_signal.bind(false))
		InterfaceManager.display_menu(roster, true)
		
func _on_inventory_button_pressed():
	var nodes = main_control.get_children()
	var index = nodes.find_custom(func (x): return x is InventoryInterface)
	if index != -1:
		InterfaceManager.close_menu(nodes[index])
	else:
		var inventory = InventoryInterface.instantiate(Player.inventory)
		inventory.tree_exited.connect(roster_button.set_pressed_no_signal.bind(false))
		InterfaceManager.display_menu(inventory, true)

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
