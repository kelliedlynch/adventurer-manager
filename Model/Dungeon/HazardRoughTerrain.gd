extends Hazard
class_name HazardRoughTerrain

var time_penalty: int = 2
var mitigated_penalty: int = 1

func _init() -> void:
	hazard_name = "Rough Terrain"
	hazard_description = "Quest takes an additional %d day(s)." % [time_penalty]
	icon = load("res://Graphics/Icons/White/falling_rocks.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Trailblazer,
			counter_action = CounterAction.IGNORES
		}
	]
