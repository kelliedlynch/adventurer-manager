extends Resource
class_name DungeonTrait

var trait_name: String

func before_quest_action(_dungeon: Dungeon):
	pass
	
func after_quest_action(_dungeon: Dungeon):
	pass
	
func per_tick_action(_dungeon: Dungeon):
	pass

func before_combat_action(_dungeon: Dungeon):
	pass

func after_combat_action(_dungeon: Dungeon):
	pass

func per_combat_round_action(_dungeon: Dungeon):
	pass
	
static var all_traits: Array[DungeonTrait] = []

func _to_string() -> String:
	return trait_name
	
static func random():
	if all_traits.is_empty():
		all_traits.append_array([DungeonTraitHighStat.new("stat_hp"), DungeonTraitHighStat.new("stat_atk"),\
			DungeonTraitHighStat.new("stat_def"), DungeonTraitClassCommon.new(Enemy.EnemyClass.PHYSICAL), \
			DungeonTraitClassCommon.new(Enemy.EnemyClass.MAGIC)])
	return all_traits.pick_random()

class DungeonTraitHighStat extends DungeonTrait:
	var stat: String
	var increase_factor: float = 1.3
	
	func _init(stat_name: String):
		stat = stat_name
		trait_name = "High " + Stats.get(stat_name).abbreviation
	
	func before_combat_action(dungeon: Dungeon):
		for enemy in dungeon.combat.enemies:
			enemy.set(stat, ceil(enemy.get(stat) * increase_factor))

class DungeonTraitClassCommon extends DungeonTrait:
	var enemy_class: Enemy.EnemyClass
	var increase_factor: float = .4
	
	func _init(e_class: Enemy.EnemyClass):
		enemy_class = e_class
		trait_name = "More " + Enemy.EnemyClass.find_key(e_class).capitalize() + " Enemies"
	
	func before_combat_action(dungeon: Dungeon):
		for i in dungeon.combat.enemies.size():
			var enemy = dungeon.combat.enemies[i]
			if enemy_class != enemy.enemy_class:
				if randf() < increase_factor:
					var enemy_number = enemy.unit_name.rsplit(" ", false, 1)[-1]
					var new_enemy = Enemy.new(enemy_class)
					new_enemy.unit_name += " " + enemy_number
					dungeon.combat.enemies[i] = new_enemy
					
