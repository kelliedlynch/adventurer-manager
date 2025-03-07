extends Resource
class_name PlayerData

var roster: ObservableArray = ObservableArray.new([], Adventurer)
var money: int = 120
var current_town: Town

var inventory: ObservableArray = ObservableArray.new([], Equipment)

#func _init() -> void:
	#Game.game_begin.connect(_on_game_begin, CONNECT_ONE_SHOT)

func initialize_player() -> void:
	add_adventurer_to_roster(Warrior.new())
	add_adventurer_to_roster(Rogue.new())
	add_adventurer_to_roster(Mage.new())
	add_adventurer_to_roster(Healer.new())
	for i in 4:
		var adv = AdventurerFactory.generate_random_newbie()
		add_adventurer_to_roster(adv)
	for i in 8:
		var item: Equipment = Equipment.generate_random_equipment()
		inventory.append(item)

	var town = Town.new()
	current_town = town

func add_adventurer_to_roster(adv: Adventurer):
	roster.append(adv)
	if adv.weapon:
		inventory.append(adv.weapon)
	if adv.armor:
		inventory.append(adv.armor)
