extends Hazard
class_name HazardPuzzles

var time_penalty: int = 2
var mitigated_penalty: int = 1
var morale_penalty: int = 3
var morale_penalty_mitigated: int = 1
var morale_loss_chance: int = 20

func _init() -> void:
	hazard_name = "Puzzles"
	hazard_description = "Quest takes an additional %d day(s). %d%% chance to lose %s morale each day." % [time_penalty, morale_loss_chance, morale_penalty]
	icon = load("res://Graphics/Icons/White/puzzle_piece.png")
	
func _get_counters() -> Array[Dictionary]:
	return [
		{
			counter_type = CounterType.TRAIT,
			countered_by = Trait.Clever,
			counter_action = CounterAction.COUNTERS
		}
	]

func _hook_on_end_tick(dungeon: Dungeon):
	if get_mitigated_state(dungeon) == MitigatedState.INACTIVE: return

	if randf() < morale_loss_chance / 100:
		dungeon.party_morale -= morale_penalty
