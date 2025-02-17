@tool
extends ReactiveField
class_name ReactiveTextField

func _process(delta: float) -> void:
	if linked_model:
		var prop_val = str(linked_model.get(get("/linked_property")))
		if self.text != prop_val:
			self.text = prop_val
