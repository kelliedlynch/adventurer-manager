extends Resource
class_name Utility

static func normalize_range(orig: Array):
	var normalized = []
	var minVal  = orig.min()
	var maxVal  = float(orig.max() - minVal)
	for i in orig.size():
		var a = (orig[i] - minVal) / maxVal
		normalized.append(a)
	return normalized

static func is_derived_from(this_class: String, base_class: String):
	var this_is_native = ClassDB.class_exists(this_class)
	var base_is_native = ClassDB.class_exists(base_class)
	if this_class == base_class: 
		#print(this_class, " is derived from ", base_class)
		return true
	if this_is_native and not base_is_native:
		#print(this_class, " is native class, and cannot be derived from ", base_class)
		return false
	if base_is_native: 
		#print(this_class, " is derived from native class", base_class, " checking class db")
		return ClassDB.is_parent_class(this_class, base_class)
	var db = ProjectSettings.get_global_class_list()
	var current_class = this_class
	while true:
		var index = db.find_custom(func(x): return x.class == current_class)
		if index == -1: 
			#print(current_class, " is not found in custom classes")
			return false
		var class_info = db[index]
		if class_info.base == base_class:
			#print(current_class, " is derived from ", base_class)
			return true
		if ClassDB.class_exists(class_info.base):
			#print(this_class, " may be derived from ", base_class, ", checking ", class_info.base, " against ", base_class)
			return is_derived_from(class_info.base, base_class)
		current_class = class_info.base

static func dict_to_hint_string(dict: Dictionary) -> String:
	var hint = ""
	for elem in dict:
		hint += str(elem) + ":" + str(dict[elem]) + ","
	return hint.left(-1)

static func array_to_hint_string(arr: Array) -> String:
	return arr.reduce(func(accum, val): return accum + val + ",", "").left(-1)

static func get_properties_of_custom_class(custom: String) -> Dictionary:
	var instance = instance_class_from_string_name(custom)
	return instance.get_property_list()

static func instance_class_from_string_name(cl_name: String) -> Variant:
	var class_list = ProjectSettings.get_global_class_list()
	var index = class_list.find_custom(func (x): return x.class == cl_name)
	var found_class = class_list[index]
	var instance = load(found_class.path).new()
	return instance
