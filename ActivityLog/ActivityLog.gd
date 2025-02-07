extends Resource
class_name ActivityLog

var _messages: Array[ActivityLogMessage] = []

signal log_changed

func push_message(msg: ActivityLogMessage) -> void:
	if _messages.is_empty() or _messages[-1].time <= msg.time:
		_messages.append(msg)
	else:
		var index = _messages.rfind_custom(func (x): return x.time <= msg.time)
		_messages.insert(index + 1, msg)
	log_changed.emit()

func get_messages(qty: int = -1) -> Array[ActivityLogMessage]:
	var len = _messages.size()
	if qty == -1 or qty >= len:
		return _messages
	else:
		return _messages.slice(len - 1 - qty)
