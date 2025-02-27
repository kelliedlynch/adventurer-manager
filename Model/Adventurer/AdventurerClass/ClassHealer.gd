extends AdventurerClass
class_name ClassHealer

var heal_mp_cost: int = 3

func _init():
	adventurer_class_name = "Healer"
	stat_weight_overrides = {
		stat_hp = 3,
		stat_mp = 3,
		stat_mag = 1.5,
		stat_res = 1.5,
		stat_cha = 1.3
	}
	#level_up_stat_bonuses = {
		#stat_hp = 1,
		#stat_mp = 1,
		#stat_mag = 1,
		#stat_def = 1,
		#stat_res = 1,
	#}
	super()

func combat_action(unit: Adventurer, combat: Combat):
	if unit.current_mp >= heal_mp_cost:
		var heal_target = combat.party.find_custom(func(x): return x.stat_hp - x.current_hp >= unit.stat_mag and x.status & ~Adventurer.STATUS_DEAD)
		if heal_target != -1:
			var msg = ActivityLogMessage.new("%s cast heal on %s" % [unit.unit_name, combat.party[heal_target].unit_name])
			Game.activity_log.push_message(msg)
			combat.party[heal_target].heal_damage(unit.stat_mag)
			unit.current_mp -= heal_mp_cost
			return
	super(unit, combat)
