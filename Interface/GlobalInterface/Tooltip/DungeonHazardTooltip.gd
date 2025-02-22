@tool
extends Tooltip
class_name DungeonHazardTooltip

var hazard: Hazard

@onready var mitigate_party: HFlowContainer = find_child("MitigateParty")
@onready var mitigate_single: HFlowContainer = find_child("MitigateSingle")
@onready var partial_mitigate_party: HFlowContainer = find_child("PartialMitigateParty")
@onready var partial_mitigate_single: HFlowContainer = find_child("PartialMitigateSingle")

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		hazard = Hazard.new()
	mitigate_party.visible = false
	mitigate_single.visible = false
	partial_mitigate_party.visible = false
	partial_mitigate_single.visible = false
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
		var attach_node: Control
		match counter.counter_action:
			Hazard.CounterAction.COUNTERS:
				attach_node = mitigate_party
			Hazard.CounterAction.REDUCES_PARTY:
				attach_node = partial_mitigate_party
			Hazard.CounterAction.IGNORES:
				attach_node = mitigate_single
			Hazard.CounterAction.REDUCES:
				attach_node = partial_mitigate_single
		attach_node.add_child(l)
	_adjust_for_child_quantity(mitigate_party)
	_adjust_for_child_quantity(mitigate_single)
	_adjust_for_child_quantity(partial_mitigate_party)
	_adjust_for_child_quantity(partial_mitigate_single)
	link_object(hazard)
	#watch_reactive_fields(hazard, self)

func _adjust_for_child_quantity(container: Container):
	var children = container.get_child_count()
	#container.visible = children > 1
	container.set_deferred("visible", children > 1)
	if children <= 2:
		return
	for i in range(1, children - 1):
		var child = container.get_child(i)
		if child is Label:
			child.text += ","
