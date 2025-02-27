extends Resource
class_name Dungeon

var dungeon_name: String = "Scary Dungeon"
var party: ObservableArray = ObservableArray.new([], Adventurer)
var staged: ObservableArray = ObservableArray.new([], Adventurer)
var max_party_size: int = 4
var max_enemies_per_encounter: int = 4
#TODO: this is a placeholder for reward estimation. Remove when reward estimation is dynamic based on
#		dungeon contents
var per_enemy: int = 3

var hazards: Array[Hazard] = []

var questing: bool = false
var quest_time: int = 3
var remaining_quest_time: int = quest_time

var _min_level: int = 1
var _max_level: int = 3
var level_range: String:
	get: return str(_min_level) + "-" + str(_max_level)

var combat: Combat
var dungeon_reward_money: int = 0

var dungeon_tier: int = 1
var dungeon_traits: Array[DungeonTrait] = []

func _init() -> void:
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_on_advance_tick)

func generate_dungeon():
	#var boosts = range(dungeon_tier + 1, dungeon_tier + 3).pick_random()
	var boosts = 6
	for i in boosts:
		if randf() < .5:
			var haz = Hazard.random()
			if not hazards.has(haz):
				hazards.append(haz)
			else: 
				i -= 1
				continue
		else:
			var dt = DungeonTrait.random()
			if not dungeon_traits.has(dt):
				dungeon_traits.append(dt)
			else: 
				i -= 1
				continue
	_min_level = dungeon_tier
	_max_level = range(dungeon_tier + 2, dungeon_tier + 4).pick_random()

func begin_quest():
	if party.size() > 0:
		for adv in party:
			adv.status |= Adventurer.STATUS_IN_DUNGEON
		questing = true
		remaining_quest_time = quest_time
		
func estimate_reward() -> Array:
	var min_reward = _min_level * per_enemy * quest_time
	var max_reward = _max_level * per_enemy * quest_time
	return range(min_reward, max_reward + 1)

func _on_advance_tick():
	if !questing:
		return
	_initialize_combat()
	_before_combat_actions()
	var result = combat.run_combat()
	_after_combat_actions()
	if result == Combat.RESULT_WIN:
		dungeon_reward_money += combat.reward_money
	elif result == Combat.RESULT_LOSS:
		complete_quest(false)
		return
	_per_tick_actions()
	if party.is_empty():
		complete_quest(false)
		return
	remaining_quest_time -= 1
	if remaining_quest_time <= 0:
		complete_quest(true)
		
func _initialize_combat():
	combat = Combat.new()
	var last_mage = 1
	var last_phys = 1
	for i in randi_range(1, max_enemies_per_encounter):
		var enemy = Enemy.new()
		var enemy_number = last_mage if enemy.enemy_class == Enemy.EnemyClass.MAGIC else last_phys
		enemy.unit_name += " " + (str(enemy_number))
		if enemy.enemy_class == Enemy.EnemyClass.MAGIC:
			last_mage += 1
		else:
			last_phys += 1
		for j in randi_range(_min_level, _max_level + 1):
			enemy.level_up()
		combat.add_unit(enemy)
	for unit in party:
		if unit.status & ~Adventurer.STATUS_DEAD:
			combat.add_unit(unit)
			
func _before_combat_actions():
	for hazard in hazards:
		hazard.before_combat_action(self)
	for dun_trait in dungeon_traits:
		dun_trait.before_combat_action(self)
		
func _after_combat_actions():
	for hazard in hazards:
		hazard.after_combat_action(self)
	for dun_trait in dungeon_traits:
		dun_trait.after_combat_action(self)
	
func _per_tick_actions():
	for haz in hazards:
		haz.per_tick_action(self)
		if party.is_empty():
			return
	for dun_trait in dungeon_traits:
		dun_trait.per_tick_action(self)
		if party.is_empty():
			return

func complete_quest(success: bool):
	remaining_quest_time = quest_time
	for adv in party:
		adv.status &= ~Adventurer.STATUS_IN_DUNGEON
	party.clear()
	var log_msg = ActivityLogMessage.new()
	log_msg.menu = DungeonInterface.instantiate.bind(self)
	if success:
		log_msg.text = "Party finished quest in %s. Received %d money." % [dungeon_name, dungeon_reward_money]
		Game.player.money += dungeon_reward_money
	else:
		log_msg.text = "All adventurers fell in %s. No rewards received." % dungeon_name
	Game.activity_log.push_message(log_msg, true)
	if success:
		var loot = Equipment.generate_random_equipment()
		loot.item_name = "Awesome Dungeon Loot"
		Game.player.inventory.append(loot)
		Game.activity_log.push_message(ActivityLogMessage.new("Received loot: %s" % loot.item_name))
	questing = false
	remaining_quest_time = quest_time
