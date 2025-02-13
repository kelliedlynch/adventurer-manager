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
	if this_class == base_class: 
		return true
	if ClassDB.class_exists(base_class): 
		return ClassDB.is_parent_class(this_class, base_class)
	var db = ProjectSettings.get_global_class_list()
	var current_class = this_class
	while true:
		var index = db.find_custom(func(x): return x.class == current_class)
		if index == -1: 
			return false
		var class_info = db[index]
		if class_info.base == current_class:
			return true
		if ClassDB.class_exists(class_info.base):
			return is_derived_from(current_class, class_info.class)
		current_class = class_info.base
