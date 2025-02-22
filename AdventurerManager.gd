extends Node

# any object that wants to update a filtered list of adventurers in response to changes in their
# properties needs to connect to this signal. That property must also emit the property_changed signal
# on the adventurer class
signal adventurer_changed

var _all_adventurers: Array[Adventurer] = []

func add_adventurer(adv: Adventurer):
	_all_adventurers.append(adv)
	adv.property_changed.connect(adventurer_changed.emit)
