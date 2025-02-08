extends Node
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

var _min_reward: int = 10:
	set(value):
		_min_reward = value
		property_changed.emit("reward_range")
var _max_reward: int = 90:
	set(value):
		_max_reward = value
		property_changed.emit("reward_range")
var reward_range: String = str(_min_reward) + "-" + str(_max_reward)

signal property_changed

func _init() -> void:
	GameplayEngine.game_tick_advanced.connect(_on_advance_tick)
	
func begin_quest():
	if party.size() > 0:
		for adv in party:
			adv.status = Adventurer.STATUS_EXPLORING_DUNGEON
		questing = true
		remaining_quest_time = quest_time
		
func complete_quest():
	for adv in party:
		adv.status = Adventurer.STATUS_IDLE
	party.clear()
	var log = ActivityLogMessage.new()
	log.menu = DungeonInterface.instantiate.bind(self)
	var reward = randi_range(_min_reward, _max_reward)
	log.text = "Party finished quest in %s. Received %d money." % [dungeon_name, reward]
	GameplayEngine.activity_log.push_message(log)
	Player.money += reward
	questing = false
	remaining_quest_time = -1

func _on_advance_tick():
	if questing:
		remaining_quest_time -= 1
		if remaining_quest_time <= 0:
			complete_quest()
