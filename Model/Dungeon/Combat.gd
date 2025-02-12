extends Resource
class_name Combat

var party: Array[Adventurer] = []
var enemies: Array[Enemy] = []
var reward_xp: int = 0
var reward_money: int = 0

func add_adventurer(adv: Adventurer):
	party.append(adv)
	adv.adventurer_died.connect(_on_adventurer_died)
	
func add_enemy(enemy: Enemy):
	enemies.append(enemy)
	enemy.enemy_died.connect(_on_enemy_died)

func _on_adventurer_died(adv: Adventurer):
	party.erase(adv)
	
func _on_enemy_died(enemy: Enemy):
	reward_xp += enemy.reward_xp
	reward_money += enemy.reward_money
	enemies.erase(enemy)

func perform_combat_round():
	for adv in party:
		adv.adventurer_class.combat_action(adv, self)
	for enemy in enemies:
		enemy.combat_action(self)
