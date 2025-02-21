@tool
extends ReactiveField
class_name ReactiveTextureField

func update_from_linked_object():
	if not linked_property: return
	var prop_val = linked_object.get(linked_property) if linked_object else null
	if prop_val != get("texture"):
		set("texture", prop_val)

func get_property_hint_string() -> String:
	var instance = Utility.instance_class_from_string_name(linked_class)
	var all_props = instance.get_property_list()
	var texture_props = all_props.filter(func(x): return instance.get(x.name) is Texture2D)
	return texture_props.reduce(func(accum, val): return accum + val.name + ",", "").left(-1)
