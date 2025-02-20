@tool
extends ReactiveField
class_name ReactiveTextField

func _process(delta: float) -> void:
	if linked_model:
		var prop_val = str(linked_model.get(linked_property))
		if self.text != prop_val:
			self.text = prop_val

func get_test_value(property: StringName):
	return self.text

func set_test_value(_property: StringName, value: Variant):
	self.text = value

func clear_test_value():
	self.text = ""
	
func _property_get_revert(property: StringName) -> Variant:
	if property == "__test_value":
		return ""
	return super(property)

func _get_property_list() -> Array:
	var props = []
	props.append({
		name = "__test_value",
		type = TYPE_STRING
	})
	return props
