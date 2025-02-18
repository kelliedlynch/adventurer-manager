@tool
extends Tooltip
class_name DungeonHazardTooltip

var hazard: Hazard = HazardCold.new()

@onready var mitigate_party: HBoxContainer = find_child("MitigateParty")
@onready var mitigate_single: HBoxContainer = find_child("MitigateSingle")
@onready var partial_mitigate_party: HBoxContainer = find_child("PartialMitigateParty")
@onready var partial_mitigate_single: HBoxContainer = find_child("PartialMitigateSingle")

func _ready() -> void:
	for counter in hazard.counters:
		var l = Label.new()
		l.theme_type_variation = "FieldBig"
		match counter.counter_type:
			Hazard.CounteredBy.CLASS:
				l.text = str(counter.countered_by) + " class"
			Hazard.CounteredBy.STAT:
				l.text = counter.countered_by.name + " > " + str(counter.countered_by_value)
			Hazard.CounteredBy.SKILL:
				l.text = counter.countered_by
			Hazard.CounteredBy.TRAIT:
				l.text = str(counter.countered_by) + " trait"
				
		match counter.counter_action:
			Hazard.CounterType.COUNTERS:
				mitigate_party.add_child(l)
			Hazard.CounterType.REDUCES_PARTY:
				partial_mitigate_party.add_child(l)
			Hazard.CounterType.IGNORES:
				mitigate_single.add_child(l)
			Hazard.CounterType.REDUCES:
				partial_mitigate_single.add_child(l)
	mitigate_party.visible = mitigate_party.get_child_count() > 1
	mitigate_single.visible = mitigate_single.get_child_count() > 1
	partial_mitigate_party.visible = partial_mitigate_party.get_child_count() > 1
	partial_mitigate_single.visible = partial_mitigate_single.get_child_count() > 1
	watch_reactive_fields(hazard, self)
