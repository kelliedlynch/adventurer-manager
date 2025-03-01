extends Resource
class_name DungeonSimulator

static var dungeon: Dungeon

static func get_result(dungeon: Dungeon):
	var party = dungeon.staged if dungeon.party.is_empty() else dungeon.party
	var sim_party = party.map(func(x): return x.duplicate(true))
	for enemies in dungeon.encounters:
		var combat = Combat.new()
		combat.enemies.append_array(enemies.map(func(x): return x.duplicate(true)))
