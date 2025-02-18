@tool
extends Interface
class_name DungeonInterface

var dungeon: Dungeon
@onready var idle_units_list: UnitListMenu = find_child("IdleUnits")
@onready var dungeon_panel: VBoxContainer = find_child("DungeonInfoPanel")
@onready var reward_amount: Label = find_child("RewardAmount")
@onready var dungeon_units_list: UnitListMenu = find_child("DungeonParty")
@onready var send_button: Button = find_child("SendParty")
@onready var party_unit_count: Label = find_child("PartyUnitsField")
@onready var dungeon_time: ReactiveTextField = find_child("DungeonTimeField")
@onready var status_window: MarginContainer = find_child("DungeonStatusWindow")
@onready var hazard_icons: HBoxContainer = find_child("HazardIcons")

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
		icon.mouse_entered.connect(_on_hazard_icon_hovered.bind(icon.hazard))
		icon.mouse_exited.connect(_on_hazard_icon_exited.bind(icon.hazard))
	_refresh_interface()
	idle_units_list.menu_item_selected.connect(_on_unit_selected)
	dungeon_units_list.menu_item_selected.connect(_on_unit_selected)
	watch_reactive_fields(dungeon, self)
	send_button.pressed.connect(_on_press_send_button)
	super()

func _get_idle_units() -> Array[Adventurer]:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		var u: Array[Adventurer] = []
		for i in 6:
			u.append(Adventurer.generate_random_newbie())
		return u
	var idle = Game.player.roster.filter(func (x): return x.status == Adventurer.STATUS_IDLE and not staged_units.has(x))
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
	
func _on_press_send_button():
	if dungeon.party.is_empty():
		dungeon.party.append_array(dungeon_units_list.units)
		for unit in dungeon.party:
			dungeon_units_list.remove_unit(unit)
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
		send_button.disabled = staged_units.is_empty()

func _process(delta: float) -> void:
	party_unit_count.text = "%d/%d" % [staged_units.size(), dungeon.max_party_size]
	status_window.visible = dungeon.questing
	dungeon_units_list.visible = !dungeon.questing

func _find_labels_for_property(prop_name: String, node: Node):
	var labels: Array[Control] = []
	for child in node.get_children():
		if child is ReactiveField and child.get("/linked_property") == prop_name:
			if child is ReactiveMultiField:
				labels.append_array(child.values_container.get_children().filter(func(x): return x is Label))
				continue
			labels.append(child)
			if child.name.right(5) == "Value":
				var field_label = child.get_parent().find_child(child.name.left(-5) + "Label", false)
				if field_label != null:
					labels.append(field_label)
		labels.append_array(_find_labels_for_property(prop_name, child))
	return labels
	
func _highlight_counter_properties(item: MenuItemBase, prop_name: String, counter: Dictionary):
	for label in _find_labels_for_property(prop_name, item):
		if prop_name == "traits" and label.text != str(counter.countered_by):
			continue
		if counter.counter_action == Hazard.CounterType.COUNTERS or counter.counter_action == Hazard.CounterType.IGNORES:
			label.add_theme_color_override("font_color", get_theme_color("success_color", "Label"))
			pass
		elif counter.counter_action == Hazard.CounterType.REDUCES_PARTY or counter.counter_action == Hazard.CounterType.REDUCES_PARTY:
			label.add_theme_color_override("font_color", get_theme_color("partial_success_color", "Label"))

func _on_hazard_icon_hovered(haz: Hazard):
	print("hazard icon hovered")
	for counter in haz.counters:
		#var partial_labels: Array[Label] = []
		#var full_labels: Array[Label] = []
		match counter.counter_type:
			Hazard.CounteredBy.CLASS:
				for item in idle_units_list.menu_items:
					if item.unit.adventurer_class == counter.countered_by:
						_highlight_counter_properties(item, "adventurer_class", counter)
			Hazard.CounteredBy.STAT:
				for item in idle_units_list.menu_items:
					if item.unit.get(counter.countered_by.name) >= counter.countered_by_value:
						_highlight_counter_properties(item, counter.countered_by.name, counter)
			Hazard.CounteredBy.TRAIT:
				for item in idle_units_list.menu_items:
					if item.unit.traits.has(counter.countered_by):
						_highlight_counter_properties(item, "traits", counter)
		#
		#if countering_party_members.is_empty(): 
			#continue
		#
		#match counter.counter_action:
			#Hazard.CounterType.COUNTERS:
				#mit_state = MitigatedState.INACTIVE
			#Hazard.CounterType.REDUCES_PARTY:
				#mit_state = MitigatedState.PARTIAL
			#Hazard.CounterType.IGNORES:
				#mit_state = MitigatedState.INACTIVE if countering_party_members.size() == party.size() else MitigatedState.PARTIAL
			#Hazard.CounterType.REDUCES:
				#mit_state = MitigatedState.PARTIAL
	#
	#pass
	
func _on_hazard_icon_exited(haz: Hazard):
	pass

static func instantiate(dun: Dungeon) -> DungeonInterface:
	var menu = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	menu.dungeon = dun
	return menu
