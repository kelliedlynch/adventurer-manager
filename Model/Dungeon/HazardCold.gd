extends Hazard
class_name HazardCold

var cold_damage: int = 2
var mage_reduction: float = .5

func _init() -> void:
	hazard_name = "Cold"
	hazard_description = "All party members take cold damage each day"
	icon = load("res://Graphics/Icons/White/snowman.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.CLASS,
			countered_by = Mage,
			counter_action = CounterAction.REDUCES_PARTY
		},
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Robust,
			counter_action = CounterAction.IGNORES
		}
	]
	
#func _traits_contain_robust(adv: Adventurer) -> bool:
	#return adv.traits.has(Trait.Robust)
#
#func _class_is_mage(adv: Adventurer) -> bool:
	#return adv.adventurer_class is ClassMage
	#
#func get_mitigated_state(dungeon: Dungeon):
	#if (!dungeon.staged.is_empty() and dungeon.staged.all(_traits_contain_robust)) or (!dungeon.party.is_empty() and dungeon.party.all(_traits_contain_robust)):
		#return MitigatedState.INACTIVE
	#if (!dungeon.staged.is_empty() and (dungeon.staged.any(_traits_contain_robust) or dungeon.staged.any(_class_is_mage))) \
		#or (!dungeon.party.is_empty() and (dungeon.party.any(_traits_contain_robust) or dungeon.party.any(_class_is_mage))):
		#return MitigatedState.PARTIAL
	#return MitigatedState.ACTIVE

func _hook_on_end_tick(dungeon: Dungeon):
	var dmg = cold_damage
	if dungeon.party.find_custom(func(x): return x is Mage) != -1:
		dmg -= dmg * mage_reduction
	for adv in dungeon.party:
		if !adv.traits.has(Trait.Robust):
			adv.take_damage(dmg, Adventurer.DamageType.TRUE)
