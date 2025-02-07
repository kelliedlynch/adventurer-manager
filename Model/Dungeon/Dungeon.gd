extends Node
class_name Dungeon

var dungeon_name: String = "Scary Dungeon"
var party: Array[Adventurer] = []
var questing: bool = false
var quest_time: int = 3
var current_quest_time: int = 0

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
		questing = true
		current_quest_time = quest_time

func _on_advance_tick():
	if questing:
		current_quest_time -= 1
		if current_quest_time <= 0:
			var log = ActivityLogMessage.new()
			log.menu = DungeonInterface
			log.text = "Party finished quest"
			GameplayEngine.activity_log.push_message(log)
			questing = false
	pass
