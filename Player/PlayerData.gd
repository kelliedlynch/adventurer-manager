extends Watchable
class_name PlayerData

var roster: Array[Adventurer] = []
var money: int = 120:
	set(value):
		money = value
		_set("money", value)
var current_town: Town

var inventory: Array[Equipment] = []

func _init() -> void:
	for i in 12:
		var adv = Adventurer.generate_random_newbie()
		roster.append(adv)
	for i in 7:
		var item = Armor.new() if randi() % 2 == 0 else Weapon.new()
		inventory.append(item)

	var town = Town.new()
	town.town_name = "Townsville"
	current_town = town
	pass
