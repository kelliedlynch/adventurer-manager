extends CombatUnit
class_name Enemy

var reward_xp: int = 100
var reward_money: int = 3

var enemy_class: EnemyClass

func _init(e_class: Variant = null) -> void:
	if e_class == null:
		e_class = EnemyClass.values().pick_random()
	enemy_class = e_class
	unit_name = "Enemy " + ("Mage" if enemy_class == EnemyClass.MAGIC else "Warrior")
	_set_base_stats()
	super()
	
func _set_base_stats():
	if enemy_class == EnemyClass.PHYSICAL:
		damage_type = DamageType.PHYSICAL
		base_stats.stat_hp = 16
		base_stats.stat_atk = 3
		base_stats.stat_def = 2
		level_up_stats.stat_hp = 3.8
		level_up_stats.stat_atk = 2
		level_up_stats.stat_def = 1
	elif enemy_class == EnemyClass.MAGIC:
		damage_type = DamageType.MAGIC
		base_stats.stat_hp = 10
		base_stats.stat_atk = 2
		base_stats.stat_def = 1
		level_up_stats.stat_hp = 3
		level_up_stats.stat_atk = 1.5
		level_up_stats.stat_def = .7

func combat_action(combat: Combat):
	var target = combat.alive_party.pick_random()
	push_attack_msg(target, stat_atk)
	target.take_damage(stat_atk, damage_type)

enum EnemyClass {
	PHYSICAL,
	MAGIC
}
