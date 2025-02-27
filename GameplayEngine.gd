extends Node

var player: PlayerData
var activity_log: ActivityLog

var dungeon: Dungeon

var _tick: int = 0
var tick: int:
	get: return _tick
	set(value): 
		push_error("cannot set tick directly; use advance_tick")
	
signal game_begin
signal game_tick_advanced
		
func advance_tick():
	_tick += 1
	game_tick_advanced.emit()

func _init() -> void:
	activity_log = ActivityLog.new()
	player = PlayerData.new()

func _ready() -> void:
	await get_tree().process_frame
	begin_game()

func begin_game() -> void:
	PhysicsServer2D.set_active(false)
	PhysicsServer3D.set_active(false)
	player.initialize_player()
	
	dungeon = Dungeon.new()
	dungeon.generate_dungeon()
	advance_tick()
