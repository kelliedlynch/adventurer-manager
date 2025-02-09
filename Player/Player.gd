extends Node
class_name PlayerData

var roster: Array[Adventurer] = []
var money: int = 120:
	set(value):
		money = value
		property_changed.emit("money")
var current_town: Town

signal property_changed

func _init() -> void:
	pass
	for i in 10:
		roster.append(Adventurer.generate_random_newbie())

func _ready() -> void:
	var town = Town.new()
	town.name = "Townsville"
	current_town = town
	pass
