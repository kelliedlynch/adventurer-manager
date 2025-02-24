extends Building
class_name Hospital

var injured_units: ObservableArray = ObservableArray.new([], Adventurer)

func _init() -> void:
	building_name = "Hospital"
	building_description = "Heal your adventurers. No gangrene, or your money back!"
	interface = HospitalInterface

func refresh_injured_units():
	var injured = Game.player.roster.filter(func(x): return x.current_hp < x.stat_hp and x.status & ~Adventurer.STATUS_IN_BUILDING)
	injured_units.append_array(injured)
