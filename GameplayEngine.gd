extends Node

@onready var player: PlayerData = PlayerData.new()
var activity_log: ActivityLog = ActivityLog.new()

var dungeon: Dungeon

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
	begin_game()

func begin_game() -> void:
	PhysicsServer2D.set_active(false)
	PhysicsServer3D.set_active(false)
	dungeon = Dungeon.new()
	advance_tick()
