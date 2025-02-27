extends Resource
class_name PlayerData

var roster: ObservableArray = ObservableArray.new([], Adventurer)
var money: int = 120
var current_town: Town

var inventory: ObservableArray = ObservableArray.new([], Equipment)

#func _init() -> void:
	#Game.game_begin.connect(_on_game_begin, CONNECT_ONE_SHOT)

func initialize_player() -> void:
	for i in 10:
		var adv = Adventurer.generate_random_newbie()
		add_adventurer_to_roster(adv)
	for i in 5:
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
