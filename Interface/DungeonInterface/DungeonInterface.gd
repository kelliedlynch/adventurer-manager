extends Control
class_name DungeonInterface

var dungeon: Dungeon
@onready var idle_units_list: UnitListMenu = $HBoxContainer/IdleUnits
@onready var dungeon_panel: VBoxContainer = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer
@onready var dungeon_units_list: UnitListMenu = $HBoxContainer/VBoxContainer/DungeonParty
@onready var send_button: Button = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/SendParty
@onready var party_status_label: Label = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/PartyStatus
@onready var remaining_time: LabeledField = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/ExploreTime

#var staged_party: Array[Adventurer] = []

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		dungeon = Dungeon.new()
	#idle_units_list.clear_menu_items()
	#dungeon_units_list.clear_menu_items()
	for unit in _get_idle_units():
		idle_units_list.add_unit(unit)
	if not is_inside_tree():
		await ready
	#for item in idle_units_list.list_items.get_children():
		#item.item_clicked.connect(_add_to_party.bind(item.unit))
	idle_units_list.menu_item_selected.connect(_add_to_party)
	dungeon_units_list.menu_item_selected.connect(_remove_from_party)
	watch_labeled_fields(dungeon, dungeon_panel)
	send_button.pressed.connect(_on_press_send_button)
	dungeon.property_changed.connect(_on_dungeon_property_changed)
	#super._ready()

func watch_labeled_fields(watched, current_node) -> void:
	for child in current_node.get_children():
		if child is LabeledField:
			child.watch_object(watched)
		watch_labeled_fields(watched, child)
			
func _get_idle_units() -> Array[Adventurer]:
	var idle = Player.roster.filter(func (x): return x.status == Adventurer.STATUS_IDLE)
	if !dungeon_units_list.units.is_empty():
		for unit in dungeon_units_list.units:
			idle.remove_at(idle.find(unit))
	return idle
	
func _on_dungeon_property_changed(prop: String):
	if prop == "questing":
		if dungeon.questing == true:
			send_button.disabled = true
			party_status_label.text = "Exploring dungeon"
			remaining_time.label = "Time left"
			remaining_time.set("/linked_property", "remaining_quest_time")
		else:
			send_button.disabled = false
			party_status_label.text = "Not ready"
			remaining_time.label = "Time"
			remaining_time.set("/linked_property", "quest_time")
	
func _on_press_send_button():
	if dungeon.party.is_empty():
		dungeon.party.append_array(dungeon_units_list.units)
		for unit in dungeon.party:
			dungeon_units_list.remove_unit(unit)
		party_status_label.text = "Party Exploring"
		dungeon.begin_quest()

func _add_to_party(item: UnitListMenuItem):
	if dungeon_units_list.units.size() >= dungeon.max_party_size:
		return
	idle_units_list.remove_unit(item.unit)
	dungeon_units_list.add_unit(item.unit)
	party_status_label.text = "Party: %d/%d" % [dungeon_units_list.units.size(), dungeon.max_party_size]
	send_button.disabled = false
	
func _remove_from_party(item: UnitListMenuItem):
	idle_units_list.add_unit(item.unit)
	dungeon_units_list.remove_unit(item.unit)
	if dungeon_units_list._units.size() == 0:
		party_status_label.text = "Not ready"
		send_button.disabled = true
	else:
		party_status_label.text = "Party: %d/%d" % [dungeon_units_list.units.size(), dungeon.max_party_size]
		send_button.disabled = false

static func instantiate(dungeon: Dungeon) -> DungeonInterface:
	var menu = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	menu.dungeon = dungeon
	return menu
