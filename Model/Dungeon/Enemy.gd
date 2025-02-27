extends CombatUnit
class_name Enemy

var reward_xp: int = 100
var reward_money: int = 3

var enemy_class: EnemyClass

func _init(e_class: Variant = null) -> void:
	super()
	if e_class == null:
		e_class = EnemyClass.values().pick_random()
	enemy_class = e_class
	unit_name = "Enemy " + ("Mage" if enemy_class == EnemyClass.MAGIC else "Warrior")
	if enemy_class == EnemyClass.PHYSICAL:
		stat_weights.stat_hp += 2
		stat_weights.stat_atk += 1
		stat_weights.stat_def += 1
		stat_weights.stat_dex += 1
	elif enemy_class == EnemyClass.MAGIC:
		stat_weights.stat_mp += 2
		stat_weights.stat_mag += 2
		stat_weights.stat_res += 1
	
	#for i in level:
		#level_up()
	#for stat in base_stats:
		#set(stat, base_stats[stat])
	#current_hp = stat_hp
	#current_mp = stat_mp

func combat_action():
	var target = combat.party.pick_random()
	push_attack_msg(target, stat_atk)
	target.take_damage(stat_atk, DamageType.PHYSICAL if enemy_class == EnemyClass.PHYSICAL else DamageType.MAGIC)

enum EnemyClass {
	PHYSICAL,
	MAGIC
}
