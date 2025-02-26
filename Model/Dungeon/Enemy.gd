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
	base_stats = {
		"stat_hp": 12,
		"stat_mp": 3,
		"stat_atk": 7,
		"stat_def": 5,
		"stat_mag": 7,
		"stat_res": 4,
		"stat_dex": 6,
		"stat_cha": 4,
		"stat_luk": 0
	}
	if enemy_class == EnemyClass.PHYSICAL:
		base_stats.stat_hp += range(4, 9).pick_random()
		base_stats.stat_atk += range(1, 4).pick_random()
		base_stats.stat_def += range(1, 4).pick_random()
		base_stats.stat_dex += range(0, 3).pick_random()
	elif enemy_class == EnemyClass.MAGIC:
		base_stats.stat_mp += range(3, 6).pick_random()
		base_stats.stat_mag += range(2, 6).pick_random()
		base_stats.stat_res += range(1, 4).pick_random()
	for stat in base_stats:
		set(stat, base_stats[stat])
	current_hp = stat_hp
	current_mp = stat_mp

func combat_action():
	var target = combat.party.pick_random()
	push_attack_msg(target, stat_atk)
	target.take_damage(stat_atk, DamageType.PHYSICAL if enemy_class == EnemyClass.PHYSICAL else DamageType.MAGIC)

enum EnemyClass {
	PHYSICAL,
	MAGIC
}
