@tool
extends ReactiveField
class_name ReactiveTextField

func _ready() -> void:
	if linked_model and get("/linked_property"):
		self.text = linked_model.get(get("/linked_property"))
	#super()

func _on_property_changed(prop_name: String):
	if prop_name == get("/linked_property"):
		self.text = str(linked_model.get(get("/linked_property")))
	super(prop_name)
