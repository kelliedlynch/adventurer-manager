@tool
extends ReactiveField
class_name ReactiveTextureField

func _process(delta: float) -> void:
	if linked_model:
		var prop_val = linked_model.get(get("/linked_property"))
		if prop_val != get("texture"):
			set("texture", prop_val)
	else:
		set("texture", null)

func get_property_hint_string() -> String:
	var instance = Utility.instance_class_from_string_name(get("/linked_class"))
	var all_props = instance.get_property_list()
	var texture_props = all_props.filter(func(x): return instance.get(x.name) is Texture2D)
	return texture_props.reduce(func(accum, val): return accum + val.name + ",", "").left(-1)
