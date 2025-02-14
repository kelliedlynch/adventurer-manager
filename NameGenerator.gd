extends Resource
class_name NameGenerator

static var rng: RandomNumberGenerator

static func new_name() -> String:
	if not rng:
		rng = RandomNumberGenerator.new()
	var syllables = rng.rand_weighted([.6, 2.4, 2, .4, .2]) + 1
	var name = ""
	var prev_end = ""
	for s in syllables:
		var syl = ""
		var has_beginning = (vowels.has(name.right(1)) or rng.randi() % syllables + 1 == 0) if name != "" else rng.randi() % 3 != 0
		if has_beginning:
			var b_cons = beginning.keys()
			b_cons.append_array(anywhere.keys())
			var b_weights = beginning.values()
			b_weights.append_array(anywhere.values())
			if forbidden_next.has(prev_end):
				for f in forbidden_next[prev_end]:
					var index = b_cons.find(f)
					if index != -1:
						b_cons.remove_at(index)
						b_weights.remove_at(index)
			syl += b_cons[rng.rand_weighted(b_weights)]
		var has_ending = !has_beginning or randi() % syllables + 1 == 0
		var vow = vowels.keys()
		var v_weights = vowels.values()
		if name == "" and !has_beginning:
			var index = vow.find("y")
			vow.remove_at(index)
			v_weights.remove_at(index)
		var current_phoneme = syl if has_beginning else prev_end
		if forbidden_next.has(current_phoneme):
			for f in forbidden_next[current_phoneme]:
				var index = vow.find(f)
				if index != -1:
					vow.remove_at(index)
					v_weights.remove_at(index)
		if !has_ending:
			for f in forbidden_endings:
				var index = vow.find(f)
				if index != -1:
					vow.remove_at(index)
					v_weights.remove_at(index)
		var vowel = vow[rng.rand_weighted(v_weights)]
		syl += vowel
		if has_ending:
			var e_cons = ending.keys()
			e_cons.append_array(anywhere.keys())
			var e_weights = ending.values()
			e_weights.append_array(anywhere.values())
			if forbidden_next.has(vowel):
				for f in forbidden_next[vowel]:
					var index = e_cons.find(f)
					if index != -1:
						e_cons.remove_at(index)
						e_weights.remove_at(index)
			var end_cons = e_cons[rng.rand_weighted(e_weights)]
			syl += end_cons
			prev_end = end_cons
		else:
			prev_end = vowel
			
		name += syl
	# TODO: check for naughty words before returning
	return name.capitalize()
		
	
const vowels: Dictionary = {
	"a": 4,
	"e": 4,
	"i": 3,
	"o": 3,
	"u": 1.5,
	"y": .3,
	"ai": 1,
	"au": .2,
	"ea": 1,
	"ee": .5,
	"ei": .1,
	"eo": .5,
	"ia": 1,
	"ie": .4,
	"io": .4,
	"oi": .2,
	"ou": .2,
	"oo": .1,
	"ua": .1,
	"ui": .1
}

const beginning: Dictionary = {
	"c": 1,
	"f": 1,
	"h": 1,
	"j": .5,
	"w": .8,
	"x": .1,
	"y": .4,
	"qu": .1,
	"bl": .6,
	"br": 1,
	"cl": 1,
	"cr": 1,
	"dr": 1,
	"fl": 1,
	"fr": 1,
	"gl": 1,
	"gr": 1,
	"kn": .1,
	"pl": 1,
	"pr": 1,
	"rh": .1,
	"sc": 1,
	"scr": .6,
	"sl": 1,
	"sp": .3,
	"str": .8,
	"sw": .1,
	"thr": .5,
	"tr": 1,
	"wh": .3,
	"zh": .2
}
const ending: Dictionary = {
	"x": .6,
	"ck": .8,
	"ct": .3,
	"ft": .2,
	"gh": .2,
	"ld": 1,
	"lt": .7,
	"mp": .4,
	"nd": 2,
	"ng": 2,
	"nt": 2,
	"ns": .8,
	"nst": .1,
	"rd": 2,
	"rf": .3,
	"rg": 1,
	"rk": 1,
	"rl": .5,
	"rm": .8,
	"rn": 1,
	"rp": .3,
	"rs": .4,
	"rst": .6,
	"rt": 1,
	"wn": .3
}
static var anywhere: Dictionary = {
	"b": 2,
	"d": 4,
	"g": 1,
	"k": 1,
	"l": 4,
	"m": 1,
	"n": 5,
	"p": 2,
	"r": 5,
	"s": 5,
	"t": 5,
	"v": .6,
	"y": .5,
	"z": .5,
	"ch": 1,
	"sh": 1,
	"sk": .5,
	"st": 1,
	"th": 1,
}
static var forbidden_next: Dictionary = {
	"ee": ["ng", "w", "y"],
	"eo": ["g", "y"],
	"i": ["rp"],
	"oi": ["ct", "ft", "ng", "rg", "rl", "rp", "sp", "x", "y"],
	"oo": ["ng"],
	"ou": ["ct", "ft", "rp", "sk", "sp", "x", "y"],
	"ng": ["n"],
	"qu": ["oo", "u", "y", "ua", "ui"],
	"u": ["w", "wn", "y"],
	"ua": ["d"],
	"v": ["p"],
	"y": ["eo", "y"]
}
static var forbidden_endings: = [
	"p", "v", "w", "ui", "ua"
]
