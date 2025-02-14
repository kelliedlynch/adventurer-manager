extends Hazard
class_name HazardCold

var cold_damage: int = 2
var mage_reduction: float = .5

func _init() -> void:
	hazard_name = "Cold"
	hazard_description = "All party members take cold damage each day"
	counters = [
		{
			"counter_type": CounteredBy.CLASS,
			"countered_by": ClassMage,
			"counter_action": REDUCES_PARTY
		},
		{
			"counter_type": CounteredBy.TRAIT,
			"countered_by": Trait.ROBUST,
			"counter_action": IGNORES
		}
	]

func per_tick_action(dungeon: Dungeon):
	var dmg = cold_damage
	if dungeon.party.find_custom(func(x): return x.adventurer_class is ClassMage) != -1:
		dmg -= dmg * mage_reduction
	for adv in dungeon.party:
		if !adv.traits.has(Trait.ROBUST):
			adv.take_damage(dmg)
			print("dealing %d cold damage to %s" % [dmg, adv.name])
		else:
			print("no damage to ", adv.name)
