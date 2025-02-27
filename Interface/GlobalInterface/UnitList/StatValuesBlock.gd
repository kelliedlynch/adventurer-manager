extends GridContainer

func _ready() -> void:
	for child in get_children():
		if child.name.begins_with("Stat"):
			var lower = child.name.to_snake_case()
			var stat = Stats.get(lower)
			child.tooltip_text = stat.abbreviation + ": " + stat.description
