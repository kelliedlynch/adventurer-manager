@tool
extends Reactive
class_name ReactiveTextField

func update_from_linked_object():
	if not linked_property: return
	if Engine.is_editor_hint() and get_test_value():
		return
	var prop_val = str(linked_object.get(linked_property)) if linked_object else ""
	if self.text != prop_val:
		self.text = prop_val

func get_test_value(_property: StringName = ""):
	return self.text

func set_test_value(_property: StringName, value: Variant):
	self.text = value
	super(_property, value)

func clear_test_value():
	self.text = ""
	super()
	
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
