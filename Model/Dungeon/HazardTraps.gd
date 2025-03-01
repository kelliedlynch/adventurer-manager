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
		}
]

func _hook_on_end_tick(dungeon: Dungeon):
	var chance = trap_chance
	var index = dungeon.party.find_custom(func(x): return x is Rogue and not x.status & CombatUnit.STATUS_DEAD)
	if index != -1:
		if randf() < chance:
			var msg = "%s disarmed a trap in %s." % [dungeon.party.get_at_index(index).unit_name, dungeon.dungeon_name]
			Game.activity_log.push_message(ActivityLogMessage.new(msg))
		return
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
