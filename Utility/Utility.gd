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

static func is_derived_from(this_class: StringName, base_class: String):
	#var this_is_native = ClassDB.class_exists(this_class)
	var base_is_native = ClassDB.class_exists(base_class)
	if this_class == base_class: 
		#print(this_class, " is derived from ", base_class)
		return true
	#if this_is_native and not base_is_native:
		##print(this_class, " is native class, and cannot be derived from ", base_class)
		#return false
	#if this_is_native and base_is_native: 
		##print("base class ", base_class, " is native, checking class db")
		#return ClassDB.is_parent_class(this_class, base_class)
	var db = ProjectSettings.get_global_class_list()
	var current_class = this_class
	while true:
		var current_is_native = ClassDB.class_exists(current_class)
		if current_is_native and base_is_native:
			return ClassDB.is_parent_class(current_class, base_class)
		if current_is_native and not base_is_native:
			return false
		#elif base_is_native:
			#return is_derived_from(current_class, base_class)
		if not current_is_native:
			var index = db.find_custom(func(x): return x.class == current_class)
			if index == -1: 
				push_error("%s not found in native or custom classes" % current_class)
				return false
			var class_info = db[index]
			if class_info.base == base_class:
				return true
			if is_derived_from(class_info.base, base_class):
				return true
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
