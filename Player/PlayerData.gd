extends Resource
class_name PlayerData

var roster: ObservableArray = ObservableArray.new([], Adventurer)
var money: int = 120
var current_town: Town

var inventory: ObservableArray = ObservableArray.new([], Equipment)

func _init() -> void:
	for i in 10:
		var adv = Adventurer.generate_random_newbie()
		roster.append(adv)
	for i in 7:
		var item = Armor.new() if randi() % 2 == 0 else Weapon.new()
		inventory.append(item)

	var town = Town.new()
	town.town_name = "Townsville"
	current_town = town
	pass
