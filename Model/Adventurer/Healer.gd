extends Adventurer
class_name Healer

var max_revive_charges: int = 1
var revive_charges: int

func _init():
	adventurer_class = "Healer"
	damage_type = CombatUnit.DamageType.MAGIC
	base_stats = {
		stat_hp = 12,
		stat_atk = 6,
		stat_def = 2,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 3,
		stat_atk = .8,
		stat_def = 1.2,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()

func _on_adventurer_died(target: Adventurer):
	if revive_charges > 0 and target.current_hp <= 0:
		var msg = "%s revived %s with a spell." % [unit_name, target.unit_name]
		Game.activity_log.push_message(ActivityLogMessage.new(msg), true)
		target.heal_damage()
		revive_charges -= 1

func _hook_on_begin_combat(combat: Combat):
	revive_charges = max_revive_charges
	for unit in combat.party:
		unit.died.connect(_on_adventurer_died.bind(unit))
		
func _hook_on_end_combat(combat: Combat):
	for unit in combat.party:
		unit.died.disconnect(_on_adventurer_died.bind(unit))
