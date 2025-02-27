extends AdventurerClass
class_name ClassHealer

var heal_mp_cost: int = 3

func _init():
	adventurer_class_name = "Healer"
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

func combat_action(unit: Adventurer, combat: Combat):
	#if unit.current_mp >= heal_mp_cost:
		#var heal_target = combat.party.find_custom(func(x): return x.stat_hp - x.current_hp >= unit.stat_mag and x.status & ~Adventurer.STATUS_DEAD)
		#if heal_target != -1:
			#var msg = ActivityLogMessage.new("%s cast heal on %s" % [unit.unit_name, combat.party[heal_target].unit_name])
			#Game.activity_log.push_message(msg)
			#combat.party[heal_target].heal_damage(unit.stat_mag)
			#unit.current_mp -= heal_mp_cost
			#return
	super(unit, combat)
