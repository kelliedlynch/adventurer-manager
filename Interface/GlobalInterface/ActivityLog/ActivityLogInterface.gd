extends MarginContainer
class_name ActivityLogInterface

@onready var log_messages: VBoxContainer = find_child("LogMessages")
@onready var log_window: PanelContainer = find_child("LogWindow")
@onready var notification_window: VBoxContainer = find_child("NotificationWindow")
@onready var scroll_container: ScrollContainer = find_child("ScrollContainer")

#func _init() -> void:
	#Game.game_begin.connect(_on_game_begin, CONNECT_ONE_SHOT)

func _ready() -> void:
#func _on_game_begin():
	Game.activity_log.log_changed.connect(_append_log_message)
	Game.activity_log.log_notify.connect(_notify_log_message)
	log_window.visible = false
	_build_log()
	
func _build_log():
	for child in log_messages.get_children():
		child.queue_free()
	for msg in Game.activity_log.get_messages():
		var item = ActivityLogTextLabel.new(msg)
		log_messages.add_child(item)
	#_scroll_to_bottom()
	#if not is_inside_tree():
		#await ready
	#scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
	
func _scroll_to_bottom():
	#if not log_window.visible:
		#await get_tree().create_timer(.5).timeout
	await get_tree().process_frame
	var a = scroll_container.get_v_scroll_bar()
	scroll_container.set_deferred("scroll_vertical", a.max_value)
#func _on_log_changed(msg: ActivityLogMessage = null, notify: bool = false):
	#_build_log()
func _append_log_message(msg: ActivityLogMessage):
	log_messages.add_child(ActivityLogTextLabel.new(msg))
	if log_window.visible:
		#await get_tree().process_frame
		call_deferred("_scroll_to_bottom")
	
func _notify_log_message(msg: ActivityLogMessage):
	if msg:
		var existing = notification_window.get_child_count()
		var notif = ActivityLogNotification.new(msg, .6 * existing)
		notification_window.add_child(notif)
	#await get_tree().create_timer(1).timeout

func toggle_window():
	log_window.visible = !log_window.visible
	if log_window.visible:
		for child in notification_window.get_children():
			child.cancel()
		call_deferred("_scroll_to_bottom")
		
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() and Input.is_action_just_pressed("ui_open_log"):
		toggle_window()
