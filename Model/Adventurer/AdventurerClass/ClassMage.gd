extends AdventurerClass
class_name ClassMage

var spell_mp_cost: int = 3

func _init():
	adventurer_class_name = "Mage"
	damage_type = CombatUnit.DamageType.MAGIC
	base_stats = {
		stat_hp = 10,
		stat_atk = 9,
		stat_def = 1,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 1.8,
		stat_atk = 1.2,
		stat_def = .4,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()

func combat_action(unit: Adventurer, combat: Combat):
	#if unit.current_mp >= spell_mp_cost:
		#var target = combat.enemies.pick_random()
		#Game.activity_log.push_message(ActivityLogMessage.new("%s cast a spell on %s for %d damage." % [unit.unit_name, target.unit_name, unit.stat_mag]))
		#target.take_damage(unit.stat_mag, Adventurer.DamageType.MAGIC)
		#unit.current_mp -= spell_mp_cost
		#return
	super(unit, combat)
