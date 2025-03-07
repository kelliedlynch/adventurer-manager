extends Adventurer
class_name Rogue

var dodge_chance: float = .3

func _init() -> void:
	adventurer_class = "Rogue"
	damage_type = CombatUnit.DamageType.PHYSICAL
	base_stats = {
		stat_hp = 10,
		stat_atk = 10,
		stat_def = 1,
		stat_cha = 1,
		stat_brv = 1
	}
	level_up_stats = {
		stat_hp = 2.1,
		stat_atk = 1.2,
		stat_def = .5,
		stat_cha = 0,
		stat_brv = 0,
	}
	super()

func take_damage(dmg: int, dmg_type = DamageType.TRUE):
	if dmg_type & DamageType.PHYSICAL and randf() < dodge_chance:
		var msg = "%s dodged! No damage taken." % [unit_name]
		Game.activity_log.push_message(ActivityLogMessage.new(msg))
	else:
		super(dmg, dmg_type)
