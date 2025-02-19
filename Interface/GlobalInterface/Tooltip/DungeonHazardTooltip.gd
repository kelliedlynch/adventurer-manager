@tool
extends Tooltip
class_name DungeonHazardTooltip

var hazard: Hazard

@onready var mitigate_party: HBoxContainer = find_child("MitigateParty")
@onready var mitigate_single: HBoxContainer = find_child("MitigateSingle")
@onready var partial_mitigate_party: HBoxContainer = find_child("PartialMitigateParty")
@onready var partial_mitigate_single: HBoxContainer = find_child("PartialMitigateSingle")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		hazard = Hazard.random()
	for counter in hazard.counters:
		var l = Label.new()
		l.theme_type_variation = "FieldBig"
		match counter.counter_type:
			Hazard.CounterType.CLASS:
				l.text = str(counter.countered_by) + " class"
			Hazard.CounterType.STAT:
				l.text = counter.countered_by.name + " > " + str(counter.countered_by_value)
			Hazard.CounterType.SKILL:
				l.text = counter.countered_by
			Hazard.CounterType.TRAIT:
				l.text = str(counter.countered_by) + " trait"
				
		match counter.counter_action:
			Hazard.CounterAction.COUNTERS:
				mitigate_party.add_child(l)
			Hazard.CounterAction.REDUCES_PARTY:
				partial_mitigate_party.add_child(l)
			Hazard.CounterAction.IGNORES:
				mitigate_single.add_child(l)
			Hazard.CounterAction.REDUCES:
				partial_mitigate_single.add_child(l)
	mitigate_party.visible = mitigate_party.get_child_count() > 1
	mitigate_single.visible = mitigate_single.get_child_count() > 1
	partial_mitigate_party.visible = partial_mitigate_party.get_child_count() > 1
	partial_mitigate_single.visible = partial_mitigate_single.get_child_count() > 1
	watch_reactive_fields(hazard, self)
