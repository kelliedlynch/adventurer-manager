extends PanelContainer

@onready var log_messages: VBoxContainer = $VBoxContainer/ScrollContainer/LogMessages

func _ready() -> void:
	GameplayEngine.activity_log.log_changed.connect(_on_log_changed)
	_build_log()
	
func _build_log():
	for child in log_messages.get_children():
		child.queue_free()
	for msg in GameplayEngine.activity_log.get_messages():
		var item = ActivityLogInterfaceItem.new(msg)
		log_messages.add_child(item)

func _on_log_changed():
	_build_log()
	pass
