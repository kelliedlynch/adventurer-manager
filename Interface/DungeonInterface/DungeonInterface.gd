extends Interface
class_name DungeonInterface

var dungeon: Dungeon
@onready var idle_units_list: UnitListMenu = find_child("IdleUnits")
@onready var dungeon_panel: VBoxContainer = find_child("DungeonInfoPanel")
@onready var reward_amount: Label = find_child("RewardAmount")
@onready var dungeon_units_list: UnitListMenu = find_child("DungeonParty")
@onready var send_button: Button = find_child("SendParty")
@onready var party_status_label: Label = find_child("PartyStatus")
@onready var remaining_time: ReactiveField = find_child("ExploreTime")
@onready var status_window: MarginContainer = find_child("DungeonStatusWindow")
@onready var hazard_icons: GridContainer = find_child("DungeonHazards")

var staged_units: Array[Adventurer] = []

#TODO: Currently does not accurately populate info panel when menu closed and reopened with party in dungeon
func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		dungeon = Dungeon.new()
	for unit in _get_idle_units():
		idle_units_list.add_unit(unit)
	if not is_inside_tree():
		await ready
	for hazard in dungeon.hazards:
		var icon = DungeonHazardIcon.instantiate(hazard, dungeon)
		hazard_icons.add_child(icon)
	_refresh_interface()
	idle_units_list.menu_item_selected.connect(_on_unit_selected)
	dungeon_units_list.menu_item_selected.connect(_on_unit_selected)
	watch_reactive_fields(dungeon, dungeon_panel)
	send_button.pressed.connect(_on_press_send_button)
	dungeon.property_changed.connect(_on_dungeon_property_changed)
	super()

func _get_idle_units() -> Array[Adventurer]:
	var idle = Player.roster.filter(func (x): return x.status == Adventurer.STATUS_IDLE and not staged_units.has(x))
	return idle
	
func _refresh_interface():
	var r = dungeon.estimate_reward()
	reward_amount.text = str(r[0]) + "-" + str(r[-1])
	var idle = _get_idle_units()
	var existing = idle_units_list.units
	if idle != existing:
		for unit in existing:
			if !idle.has(unit):
				idle_units_list.remove_unit(unit)
		for unit in idle:
			if !existing.has(unit):
				idle_units_list.add_unit(unit)
	var staged = dungeon_units_list.units
	if staged_units != staged:
		for unit in staged:
			if !staged_units.has(unit):
				dungeon_units_list.remove_unit(unit)
		for unit in staged_units:
			if !staged.has(unit):
				dungeon_units_list.add_unit(unit)
	status_window.visible = dungeon.questing
	dungeon_units_list.visible = !dungeon.questing
	send_button.disabled = dungeon.questing
	if dungeon.questing:
		party_status_label.text = "Exploring dungeon"
		remaining_time.label = "Time left"
		remaining_time.set("/linked_property", "remaining_quest_time")
	else:
		remaining_time.label = "Time"
		remaining_time.set("/linked_property", "quest_time")
		if staged_units.is_empty():
			party_status_label.text = "Not ready"
		else:
			party_status_label.text = "Party: %d/%d" % [staged_units.size(), dungeon.max_party_size]
	for icon in hazard_icons.get_children():
		icon.refresh_icon()
	
func _on_dungeon_property_changed(prop: String):
	if prop == "questing":
		_refresh_interface()
	
func _on_press_send_button():
	if dungeon.party.is_empty():
		dungeon.party.append_array(dungeon_units_list.units)
		for unit in dungeon.party:
			dungeon_units_list.remove_unit(unit)
		party_status_label.text = "Party Exploring"
		staged_units.clear()
		dungeon.staged.clear()
		dungeon.begin_quest()

func _on_unit_selected(item: UnitListMenuItem, selected: bool):
	if dungeon.questing: return
	if selected:
		if staged_units.has(item.unit):
			dungeon.staged.erase(item.unit)
			staged_units.erase(item.unit)
			idle_units_list.add_unit(item.unit)
			dungeon_units_list.remove_unit(item.unit)
		elif staged_units.size() < dungeon.max_party_size:
			dungeon.staged.append(item.unit)
			staged_units.append(item.unit)
			dungeon_units_list.add_unit(item.unit)
			idle_units_list.remove_unit(item.unit)
		if staged_units.is_empty():
			party_status_label.text = "Not ready"
		else:
			party_status_label.text = "Party: %d/%d" % [staged_units.size(), dungeon.max_party_size]
		send_button.disabled = staged_units.is_empty()
	for icon in hazard_icons.get_children():
		icon.refresh_icon()

static func instantiate(dun: Dungeon) -> DungeonInterface:
	var menu = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	menu.dungeon = dun
	return menu
