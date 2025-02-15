extends Resource
class_name Watchable

signal property_changed

# example watchable property
var _foo = 0:
	set(value):
		_foo = value
		_set("_foo", value)

var watchable_props: Array[String] = ["_foo"]

func _set(property: StringName, value: Variant) -> bool:
	if watchable_props.has(property):
		property_changed.emit(property, value)
		# does this do anything? I think _set isn't even called if it's a base class property
		if property in Resource:
			return false
		return true
	return false
