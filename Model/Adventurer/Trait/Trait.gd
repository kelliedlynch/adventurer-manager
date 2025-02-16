@tool
extends Resource
class_name Trait

var trait_name: String

func _init(called: String):
	trait_name = called
	
func _to_string() -> String:
	return trait_name

static var Robust := Trait.new("Robust")
static var Clever := Trait.new("Clever")
static var Tactician := Trait.new("Tactician")
static var Trailblazer := Trait.new("Trailblazer")
static var EagleEye := Trait.new("Eagle Eye")
static var Leader := Trait.new("Leader")
static var Cautious := Trait.new("Cautious")

static var TraitList := [Robust, Clever, Tactician, Trailblazer, EagleEye, Leader, Cautious]
