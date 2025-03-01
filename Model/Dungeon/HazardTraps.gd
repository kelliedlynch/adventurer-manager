extends Hazard
class_name HazardTraps

var trap_damage: int = 5
var trap_chance: float = .5
var mitigated_reduction: float = .2

func _init() -> void:
	hazard_name = "Traps"
	hazard_description = "Chance of taking serious damage between combats."
	icon = load("res://Graphics/Icons/White/tripwire.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = Rogue,
			counter_action = CounterAction.COUNTERS
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.EagleEye,
			counter_action = CounterAction.REDUCES_PARTY
		},
		#{
			#counter_type = CounterType.STAT,
			#countered_by = Stats.stat_luk,
			#countered_by_value = 3,
			#counter_action = CounterAction.IGNORES
		#},
		#{
			#counter_type = CounterType.STAT,
			#countered_by = Stats.stat_dex,
			#countered_by_value = 8,
			#counter_action = CounterAction.REDUCES
		#}
]

func per_tick_action(dungeon: Dungeon):
	var chance = trap_chance
	if dungeon.party.find_custom(func(x): return x.traits.has(Trait.EagleEye)) != -1:
		chance -= mitigated_reduction
	for unit in dungeon.party:
		if unit.status & Adventurer.STATUS_DEAD:
			continue
		var actions = _get_unit_counter_actions(unit)
		if actions.has(CounterAction.IGNORES):
			continue
		if actions.has(CounterAction.REDUCES):
			chance -= mitigated_reduction
		if randf() < chance:
			var dmg_type = Adventurer.DamageType.PHYSICAL if randi() % 2 == 0 else Adventurer.DamageType.MAGIC
			var msg = ActivityLogMessage.new("A trap dealt %d damage to %s." % [trap_damage, unit.unit_name])
			Game.activity_log.push_message(msg)
			unit.take_damage(int(trap_damage), dmg_type)
