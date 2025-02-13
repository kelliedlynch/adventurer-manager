extends Resource
class_name Dungeon

var dungeon_name: String = "Scary Dungeon"
var party: Array[Adventurer] = []
var max_party_size: int = 4
var questing: bool = false:
	set(value):
		questing = value
		property_changed.emit("questing")
var quest_time: int = 3:
	set(value):
		quest_time = value
		property_changed.emit("quest_time")
var remaining_quest_time: int = -1:
	set(value):
		remaining_quest_time = value
		property_changed.emit("remaining_quest_time")

var _min_level: int = 1:
	set(value):
		_min_level = value
		property_changed.emit("level_range")
var _max_level: int = 5:
	set(value):
		_max_level = value
		property_changed.emit("level_range")
var level_range: String = str(_min_level) + "-" + str(_max_level)

#var _min_reward: int = 10:
	#set(value):
		#_min_reward = value
		#property_changed.emit("reward_range")
#var _max_reward: int = 90:
	#set(value):
		#_max_reward = value
		#property_changed.emit("reward_range")
#var reward_range: String = str(_min_reward) + "-" + str(_max_reward)

var combat: Combat
var dungeon_reward_money: int = 0

signal property_changed

func _init() -> void:
	if not Engine.is_editor_hint():
		GameplayEngine.game_tick_advanced.connect(_on_advance_tick)
	
func begin_quest():
	if party.size() > 0:
		for adv in party:
			adv.status |= Adventurer.STATUS_IN_DUNGEON
		questing = true
		remaining_quest_time = quest_time

func _on_advance_tick():
	if !questing:
		return
	combat = Combat.new()
	for i in randi_range(1,4):
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
		Player.money += dungeon_reward_money
	else:
		log_msg.text = "All adventurers fell in %s. No rewards received." % dungeon_name
	GameplayEngine.activity_log.push_message(log_msg)
	questing = false
	remaining_quest_time = -1
