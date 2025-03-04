@tool
extends Reactive
class_name DungeonInterface

@onready var idle_units_list: UnitListMenu = find_child("IdleUnits")
@onready var dungeon_panel: VBoxContainer = find_child("DungeonInfoPanel")
@onready var reward_amount: Label = find_child("RewardAmount")
@onready var staged_units_list: UnitListMenu = find_child("DungeonParty")
@onready var send_button: Button = find_child("SendParty")
@onready var party_unit_count: Label = find_child("PartyUnitsField")
@onready var dungeon_time: ReactiveTextField = find_child("DungeonTimeField")
@onready var status_window: DungeonStatusWindow = find_child("DungeonStatusWindow")
@onready var hazard_icons: HBoxContainer = find_child("HazardIcons")
#@onready var dungeon_time_field: ReactiveTextField = find_child("DungeonTimeField")

#var staged_units: ObservableArray = ObservableArray.new([], Adventurer)
var idle_units: ObservableArray = ObservableArray.new([], Adventurer)

func _init() -> void:
	pass

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var dun = Dungeon.new()
		for i in 4:
			dun.party.append(AdventurerFactory.generate_random_newbie())
		link_object(dun)
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_refresh_idle_unit_list)
	idle_units_list.menu_item_selected.connect(_on_unit_selected)
	staged_units_list.menu_item_selected.connect(_on_unit_selected)
	send_button.pressed.connect(_on_press_send_button)
	
func _refresh_idle_unit_list():
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		idle_units.clear()
		for i in 6:
			idle_units.append(AdventurerFactory.generate_random_newbie())
		return
	var idle = Game.player.roster.filter(func (x): return x.status == Adventurer.STATUS_IDLE and not linked_object.staged.has(x))
	if idle_units_list.linked_object == null:
		idle_units_list.link_object(idle_units)
	if not idle_units.is_equal(idle):
		idle_units.clear()
		idle_units.append_array(idle)
	
func _on_press_send_button():
	if linked_object.party.is_empty():
		linked_object.party.append_array(linked_object.staged)
		linked_object.staged.clear()
		linked_object.begin_quest()
		status_window.visible = true

func _on_unit_selected(item: UnitListMenuItem, selected: bool):
	if linked_object.questing: return
	var unit = item.linked_object
	if selected:
		if linked_object.staged.has(unit):
			linked_object.staged.erase(unit)
			#idle_units.append(unit)
			_refresh_idle_unit_list()
		elif linked_object.staged.size() < linked_object.max_party_size:
			linked_object.staged.append(unit)
			#idle_units.erase(unit)
			_refresh_idle_unit_list()
		send_button.disabled = linked_object.staged.is_empty()

func update_from_linked_object():
	party_unit_count.text = "%d/%d" % [linked_object.staged.size(), linked_object.max_party_size]
	status_window.visible = linked_object.questing
	staged_units_list.visible = !linked_object.questing

func _find_fields_for_property(prop_name: String, node: Node):
	var fields: Array[Control] = []
	for child in node.get_children():
		if child is Reactive and child.linked_property == prop_name:
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
			if item.linked_object.traits.has(counter.countered_by):
				prop_name = "traits"
		Hazard.CounterType.STAT:
			if item.linked_object.get(counter.countered_by.property_name) >= counter.countered_by_value:
				prop_name = counter.countered_by.property_name
		Hazard.CounterType.SKILL:
			pass
		Hazard.CounterType.CLASS:
			if is_instance_of(item.linked_object, counter.countered_by):
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
		for item in idle_units_list.get_menu_items():
			_highlight_props_that_counter(item, counter)
		for item in staged_units_list.get_menu_items():
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
		for item in idle_units_list.get_menu_items():
			_clear_highlights_for_property(item, prop_name)
		for item in staged_units_list.get_menu_items():
			_clear_highlights_for_property(item, prop_name)
			
func link_object(obj: Variant, node: Node = self, _recursive = false):
	super(obj, node, obj is Dungeon)
	if node == self and obj is Dungeon:
		if not is_inside_tree():
			await ready
		staged_units_list.link_object(obj.staged)
		#idle_units_list.link_object(idle_units)
		_refresh_idle_unit_list()
		
		for hazard in obj.hazards:
			var icon = DungeonHazardIcon.instantiate(hazard, obj)
			hazard_icons.add_child(icon)
			icon.mouse_entered.connect(_on_hazard_icon_hovered.bind(hazard))
			icon.mouse_exited.connect(_on_hazard_icon_exited.bind(hazard))
		status_window.link_object(obj)
	

static func instantiate(dun: Dungeon) -> DungeonInterface:
	var interface = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	interface.link_object(dun)
	return interface
