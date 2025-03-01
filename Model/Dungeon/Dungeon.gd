extends Resource
class_name Dungeon

var dungeon_name: String = "Scary Dungeon"
var party: ObservableArray = ObservableArray.new([], Adventurer)
var alive_party: Array[Adventurer] = []:
	get: 
		var p: Array[Adventurer] = []
		p.append_array(party.filter(func(x): return not x.status & CombatUnit.STATUS_DEAD))
		return p
var staged: ObservableArray = ObservableArray.new([], Adventurer)
var max_party_size: int = 4
var max_enemies_per_encounter: int = 4
#TODO: this is a placeholder for reward estimation. Remove when reward estimation is dynamic based on
#		dungeon contents
var per_enemy: int = 3

var hazards: Array[Hazard] = []

var encounters = []

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

var party_morale: int

func _init() -> void:
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_on_advance_tick)

func generate_dungeon():
	#var boosts = range(dungeon_tier + 1, dungeon_tier + 3).pick_random()
	var boosts = dungeon_tier + 2
	for i in boosts:
		var haz = Hazard.random()
		if not hazards.has(haz):
			hazards.append(haz)
		else: 
			i -= 1
			continue
	_min_level = dungeon_tier
	_max_level = _min_level + round(dungeon_tier * .6)
	for day in quest_time:
		var encounter: Array[Enemy] = []
		for i in randi_range(1, max_enemies_per_encounter):
			var last_mage = 1
			var last_phys = 1
			var enemy = Enemy.new()
			var enemy_number = last_mage if enemy.enemy_class == Enemy.EnemyClass.MAGIC else last_phys
			enemy.unit_name += " " + (str(enemy_number))
			if enemy.enemy_class == Enemy.EnemyClass.MAGIC:
				last_mage += 1
			else:
				last_phys += 1
			for j in randi_range(0, _max_level - _min_level):
				enemy.level_up()
			encounter.append(enemy)
		encounters.append(encounter)

func begin_quest():
	if party.size() > 0:
		for adv in party:
			adv.status |= Adventurer.STATUS_IN_DUNGEON
			adv.died.connect(_on_party_member_died.bind(adv))
		questing = true
		remaining_quest_time = quest_time
		party_morale = party.reduce(func(accum, val): return accum + val.stat_brv, 0)
		
func _on_party_member_died(unit: Adventurer):
	party_morale -= unit.stat_cha
		
func estimate_reward() -> Array:
	var min_reward = _min_level * per_enemy * quest_time
	var max_reward = _max_level * per_enemy * quest_time
	return range(min_reward, max_reward + 1)

func _on_advance_tick():
	if !questing:
		return
	_initialize_combat(encounters[quest_time - remaining_quest_time])
	_before_combat_actions()
	var result = combat.run_combat()
	_after_combat_actions()
	# TODO: morale checks should probably be event-based, but I don't want to figure out the timing right now
	if party_morale < dungeon_tier + 2:
		var msg = "Your adventurers were not brave enough to complete %s. No rewards received." % dungeon_name
		Game.activity_log.push_message(ActivityLogMessage.new(msg), true)
		complete_quest(false)
		return
	if result == Combat.RESULT_WIN:
		dungeon_reward_money += combat.reward_money
	elif result == Combat.RESULT_LOSS:
		var msg = "All adventurers fell in combat in %s. No rewards received." % dungeon_name
		Game.activity_log.push_message(ActivityLogMessage.new(msg), true)
		complete_quest(false)
		return
	_per_tick_actions()
	if alive_party.is_empty():
		var msg = "Hazards in %s took out your adventuring party. No rewards received." % dungeon_name
		Game.activity_log.push_message(ActivityLogMessage.new(msg), true)
		complete_quest(false)
		return
	remaining_quest_time -= 1
	if remaining_quest_time <= 0:
		complete_quest(true)
		
func _initialize_combat(enemies: Array[Enemy]):
	combat = Combat.new()
	for enemy in enemies:
		combat.add_unit(enemy)
	for unit in party:
		if unit.status & ~Adventurer.STATUS_DEAD:
			combat.add_unit(unit)
			
func _before_combat_actions():
	for hazard in hazards:
		hazard._hook_on_begin_combat(self)

func _after_combat_actions():
	for hazard in hazards:
		hazard._hook_on_end_combat(self)

func _per_tick_actions():
	for haz in hazards:
		haz._hook_on_end_tick(self)
		if alive_party.is_empty():
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
	#else:
		#log_msg.text = "All adventurers fell in %s. No rewards received." % dungeon_name
		Game.activity_log.push_message(log_msg, true)
	if success:
		var loot = Equipment.generate_random_equipment()
		loot.item_name = "Awesome Dungeon Loot"
		Game.player.inventory.append(loot)
		Game.activity_log.push_message(ActivityLogMessage.new("Received loot: %s" % loot.item_name))
	questing = false
	remaining_quest_time = quest_time
