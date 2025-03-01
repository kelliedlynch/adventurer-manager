extends Resource
class_name AdventurerFactory

#static var primary_classes = [Warrior, Mage, Rogue, Healer]
		
static func generate_random_newbie() -> Adventurer:
	var primary_classes = [Warrior, Mage, Rogue, Healer]
	var noob = primary_classes.pick_random().new()
	noob.traits.append(Trait.TraitList.pick_random())
	noob.portrait = get_random_portrait()
	if randi() % 2 == 0:
		var equipment = Equipment.generate_random_equipment()
		noob.equip(equipment)
	return noob

static func get_random_portrait():
	var portraits = ResourceLoader.list_directory("res://Graphics/Portraits")
	var filename = portraits[randi_range(0, portraits.size() - 1)]
	return load("res://Graphics/Portraits/" + filename)
