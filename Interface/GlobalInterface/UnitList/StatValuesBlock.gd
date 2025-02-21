@tool
extends Reactive

#func _ready() -> void:
	#_configure_reactive_fields()
	
func _configure_reactive_fields(node: Node = self):
	if node is Reactive:
		node.linked_class = "Adventurer"
		if "linked_property" in node:
			node.linked_property = "stat_" + node.name.left(-5).to_lower().right(3)
	for child in node.get_children():
		_configure_reactive_fields(child)
