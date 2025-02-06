extends Node
class_name Dungeon

var dungeon_name: String = "Scary Dungeon"
var party: Array[Adventurer] = []
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
