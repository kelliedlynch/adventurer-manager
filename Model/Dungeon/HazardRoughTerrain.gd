@tool
extends Hazard
class_name HazardRoughTerrain

var percent_damage_chance: float = .6
var terrain_damage: int = 1

func _init() -> void:
	hazard_name = "Rough Terrain"
	hazard_description = "%s reduced in battle. Chance of taking damage each day." % [Stats.stat_dex.name]
	icon = load("res://Graphics/Icons/White/warning.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Trailblazer,
			counter_action = CounterAction.IGNORES
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_dex,
			countered_by_value = 6,
			counter_action = CounterAction.IGNORES
		},
		{
			counter_type = CounterType.STAT,
			countered_by = Stats.stat_luk,
			countered_by_value = 1,
			counter_action = CounterAction.REDUCES
		}
	]

func per_tick_action(dungeon: Dungeon):
	for unit in dungeon.party:
		if unit.status & Adventurer.STATUS_INCAPACITATED:
			continue
		var actions = unit_counter_actions(unit)
		var chance = percent_damage_chance
		if actions.has(CounterAction.IGNORES):
			continue
		if actions.has(CounterAction.REDUCES):
			chance *= .5
		if randf() < chance:
			unit.take_damage(int(terrain_damage))

func before_combat_action(dungeon: Dungeon):
	pass

func after_combat_action(dungeon: Dungeon):
	pass
