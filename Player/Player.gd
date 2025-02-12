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
	for i in 6:
		var adv = Adventurer.generate_random_newbie()
		roster.append(adv)

func _ready() -> void:
	var town = Town.new()
	town.name = "Townsville"
	current_town = town
	pass
