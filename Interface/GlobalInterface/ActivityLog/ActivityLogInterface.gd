extends Interface
class_name ActivityLogInterface

@onready var log_messages: VBoxContainer = find_child("LogMessages")
@onready var log_window: PanelContainer = find_child("LogWindow")
@onready var notification_window: VBoxContainer = find_child("NotificationWindow")

func _ready() -> void:
	GameplayEngine.activity_log.log_changed.connect(_on_log_changed)
	_build_log()
	
func _build_log():
	for child in log_messages.get_children():
		child.queue_free()
	for msg in GameplayEngine.activity_log.get_messages():
		var item = ActivityLogTextLabel.new(msg)
		log_messages.add_child(item)

func _on_log_changed(msg: ActivityLogMessage = null):
	_build_log()
	if msg:
		var notif = ActivityLogNotification.new()
		notif.add_child(ActivityLogTextLabel.new(msg))
		pass

func toggle_window():
	log_window.visible = !log_window.visible
