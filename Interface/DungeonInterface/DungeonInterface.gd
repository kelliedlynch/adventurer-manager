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
@onready var status_window: DungeonStatusWindow = find_child("DungeonStatusWindow")
@onready var hazard_icons: HBoxContainer = find_child("HazardIcons")

var staged_units: Array[Adventurer] = []

#TODO: Currently does not accurately populate info panel when menu closed and reopened with party in dungeon
func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		dungeon = Dungeon.new()
		for i in 4:
			dungeon.party.append(Adventurer.generate_random_newbie())
		status_window.party = dungeon.party
		dungeon.questing = true
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
		status_window.party = dungeon.party

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

func _process(_delta: float) -> void:
	party_unit_count.text = "%d/%d" % [staged_units.size(), dungeon.max_party_size]
	#status_window.visible = dungeon.questing
	#dungeon_units_list.visible = !dungeon.questing

func _find_fields_for_property(prop_name: String, node: Node):
	var fields: Array[Control] = []
	for child in node.get_children():
		if child is ReactiveField and child.get("/linked_property") == prop_name:
			if child is ReactiveMultiField:
				fields.append_array(child.values_container.get_children().filter(func(x): return x is Label))
				continue
			fields.append(child)
			if child.name.right(5) == "Value":
				var field_label = child.get_parent().find_child(child.name.left(-5) + "Label", false)
				if field_label != null:
					fields.append(field_label)
		fields.append_array(_find_fields_for_property(prop_name, child))
	return fields
	
func _highlight_props_that_counter(item: UnitListMenuItem, counter: Dictionary):
	var prop_name = ""
	match counter.counter_type:
		Hazard.CounterType.TRAIT:
			if item.unit.traits.has(counter.countered_by):
				prop_name = "traits"
		Hazard.CounterType.STAT:
			if item.unit.get(counter.countered_by.property_name) >= counter.countered_by_value:
				prop_name = counter.countered_by.property_name
		Hazard.CounterType.SKILL:
			pass
		Hazard.CounterType.CLASS:
			if item.unit.adventurer_class == counter.countered_by:
				prop_name = "adventurer_class"
	if prop_name == "":
		return
	var fields = _find_fields_for_property(prop_name, item)
	for field in fields:
		if counter.counter_type == Hazard.CounterType.TRAIT and field.text != str(counter.countered_by):
			continue
		if counter.counter_action == Hazard.CounterAction.COUNTERS or counter.counter_action == Hazard.CounterAction.IGNORES:
			_highlight_field(field, get_theme_color("success_color", "Label"))
		elif counter.counter_action == Hazard.CounterAction.REDUCES_PARTY or counter.counter_action == Hazard.CounterAction.REDUCES_PARTY:
			_highlight_field(field, get_theme_color("partial_success_color", "Label"))
		else:
			continue

func _highlight_field(field: Control, highlight_color: Color):
	if field is Label:
		field.add_theme_color_override("font_color", highlight_color)
	else:
		field.modulate = highlight_color

func _clear_highlights_for_property(item: UnitListMenuItem, prop_name: String):
	for field in _find_fields_for_property(prop_name, item):
		if field is Label and field.has_theme_color_override("font_color"):
			field.remove_theme_color_override("font_color")
		elif not field is Label and field.modulate != Color.WHITE:
			field.modulate = Color.WHITE


func _on_hazard_icon_hovered(haz: Hazard):
	for counter in haz.counters:
		#match counter.counter_type:
			#Hazard.CounterType.TRAIT:
				#prop_name = "traits"
			#Hazard.CounterType.STAT:
				#prop_name = str(counter.countered_by)
			#Hazard.CounterType.SKILL:
				#pass
			#Hazard.CounterType.CLASS:
				#prop_name = "adventurer_class"
		for item in idle_units_list.menu_items:
			_highlight_props_that_counter(item, counter)
		for item in dungeon_units_list.menu_items:
			_highlight_props_that_counter(item, counter)
	
func _on_hazard_icon_exited(haz: Hazard):
	var prop_name = ""
	for counter in haz.counters:
		match counter.counter_type:
			Hazard.CounterType.TRAIT:
				prop_name = "traits"
			Hazard.CounterType.STAT:
				prop_name = counter.countered_by.property_name
			Hazard.CounterType.SKILL:
				pass
			Hazard.CounterType.CLASS:
				prop_name = "adventurer_class"
		for item in idle_units_list.menu_items:
			_clear_highlights_for_property(item, prop_name)
		for item in dungeon_units_list.menu_items:
			_clear_highlights_for_property(item, prop_name)
#func _color_hazard_counter_stats(haz: Hazard):
	#for counter in haz.counters:
		#match counter.counter_type:
			#Hazard.CounterType.CLASS:
				#for item in idle_units_list.menu_items:
					#if item.unit.adventurer_class == counter.countered_by:
						#_highlight_counter_properties(item, "adventurer_class", counter)
			#Hazard.CounterType.STAT:
				#for item in idle_units_list.menu_items:
					#if item.unit.get(counter.countered_by.name) >= counter.countered_by_value:
						#_highlight_counter_properties(item, counter.countered_by.name, counter)
			#Hazard.CounterType.TRAIT:
				#for item in idle_units_list.menu_items:
					#if item.unit.traits.has(counter.countered_by):
						#_highlight_counter_properties(item, "traits", counter)
	
	
	
	#for label in _find_labels_for_property(prop_name, item):
		#if prop_name == "traits" and label.text != str(counter.countered_by):
			#continue
		#if counter.counter_action == Hazard.CounterAction.COUNTERS or counter.counter_action == Hazard.CounterAction.IGNORES:
			#if label is Label:
				#label.add_theme_color_override("font_color", get_theme_color("success_color", "Label"))
			#else:
				#label.modulate = get_theme_color("success_color", "Label")
		#elif counter.counter_action == Hazard.CounterAction.REDUCES_PARTY or counter.counter_action == Hazard.CounterAction.REDUCES_PARTY:
			#if label is Label:
				#label.add_theme_color_override("font_color", get_theme_color("partial_success_color", "Label"))
			#else:
				#label.modulate = get_theme_color("success_color", "Label")

static func instantiate(dun: Dungeon) -> DungeonInterface:
	var menu = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	menu.dungeon = dun
	return menu
