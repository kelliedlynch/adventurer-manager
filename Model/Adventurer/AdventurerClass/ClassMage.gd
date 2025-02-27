extends AdventurerClass
class_name ClassMage

var spell_mp_cost: int = 3

func _init():
	adventurer_class_name = "Mage"
	stat_weight_overrides = {
		stat_hp = 1,
		stat_mp = 3,
		stat_atk = .5,
		stat_def = .7,
		stat_mag = 3,
		stat_res = 2,
	}
	super()

func combat_action(unit: Adventurer, combat: Combat):
	if unit.current_mp >= spell_mp_cost:
		var target = combat.enemies.pick_random()
		Game.activity_log.push_message(ActivityLogMessage.new("%s cast a spell on %s for %d damage." % [unit.unit_name, target.unit_name, unit.stat_mag]))
		target.take_damage(unit.stat_mag, Adventurer.DamageType.MAGIC)
		unit.current_mp -= spell_mp_cost
		return
	super(unit, combat)
