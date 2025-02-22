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
var _max_level: int = 5
var level_range: String = str(_min_level) + "-" + str(_max_level)

var combat: Combat
var dungeon_reward_money: int = 0

func _init() -> void:
	if not Engine.is_editor_hint():
		Game.game_tick_advanced.connect(_on_advance_tick)
	hazards.append(Hazard.Cold)
	hazards.append(Hazard.Swarms)
	hazards.append(Hazard.RoughTerrain)
	
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
	combat = Combat.new()
	for i in randi_range(1, max_enemies_per_encounter):
		var enemy = Enemy.new()
		enemy.stat_hp = 12 + randi_range(_min_level, _max_level) * 3
		enemy.current_hp = enemy.stat_hp
		enemy.stat_atk = 3 + randi_range(_min_level, _max_level)
		combat.add_unit(enemy)
	for unit in party:
		combat.add_unit(unit)
	var result = combat.run_combat()
	if result == Combat.RESULT_WIN:
		dungeon_reward_money += combat.reward_money
	elif result == Combat.RESULT_LOSS:
		complete_quest(false)
		remaining_quest_time = -1
		return
	for haz in hazards:
		haz.per_tick_action(self)
		if party.is_empty():
			complete_quest(false)
			remaining_quest_time = -1
			return
	remaining_quest_time -= 1
	if remaining_quest_time <= 0:
		complete_quest(true)
	
func complete_quest(success: bool):
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
	Game.activity_log.push_message(log_msg)
	questing = false
	remaining_quest_time = quest_time
