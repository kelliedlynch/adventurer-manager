extends Node

var _tick: int = 0
var tick: int:
	get: return _tick
	set(value): 
		push_error("cannot set tick directly; use advance_tick")
	
signal game_tick_advanced
		
func advance_tick():
	_tick += 1
	game_tick_advanced.emit()

func _ready() -> void:
	await get_tree().process_frame
	advance_tick()
