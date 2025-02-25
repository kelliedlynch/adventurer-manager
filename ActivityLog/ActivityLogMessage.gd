extends Resource
class_name ActivityLogMessage

var menu: Variant
var time: int = Game.tick
var text: String

func _init(txt = "", onclick = null) -> void:
	text = txt
	menu = onclick
