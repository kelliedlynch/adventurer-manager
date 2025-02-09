extends Building
class_name Hospital

func _init() -> void:
	building_name = "Sawbones Express"
	building_description = "Heal your adventurers. No gangrene, or your money back!"
	interface = HospitalInterface
