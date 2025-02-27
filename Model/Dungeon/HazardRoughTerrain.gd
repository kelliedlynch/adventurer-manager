extends Hazard
class_name HazardRoughTerrain

var percent_damage_chance: float = .6
var terrain_damage: int = 1
var def_penalty: int = 2
var def_penalty_reduction: float = .5

func _init() -> void:
	hazard_name = "Rough Terrain"
	hazard_description = "%s reduced in battle. Chance of taking damage each day." % [Stats.stat_def.name]
	icon = load("res://Graphics/Icons/White/falling_rocks.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Trailblazer,
			counter_action = CounterAction.IGNORES
		}
	]

func per_tick_action(dungeon: Dungeon):
	for unit in dungeon.party:
		if unit.status & Adventurer.STATUS_DEAD:
			continue
		var actions = unit_counter_actions(unit)
		var chance = percent_damage_chance
		if actions.has(CounterAction.IGNORES):
			continue
		if actions.has(CounterAction.REDUCES):
			chance *= .5
		if randf() < chance:
			unit.take_damage(int(terrain_damage), Adventurer.DamageType.TRUE)

func before_combat_action(dungeon: Dungeon):
	for unit in dungeon.party:
		var actions = unit_counter_actions(unit)
		if actions.has(CounterAction.IGNORES):
			continue
		var buff = Buff.new()
		buff.source = self
		buff.stat_def = -def_penalty
		if actions.has(CounterAction.REDUCES):
			buff.stat_def = int(buff.stat_def * def_penalty_reduction)
		unit.buffs.append(buff)

#func after_combat_action(dungeon: Dungeon):
	#remove_own_buffs(dungeon.party)
