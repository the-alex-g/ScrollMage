extends Object

var actions := [
	AttackAction.new(1, {}, 1, 30),
	RangedAttackAction.new(1, {}, 1, 200, "res://Attacks/Projectiles/BasicAttack.tscn"),
	BoostAction.new(1, {"block":3}),
	HexAction.new(1, {"poison":3}, 100),
	MonsterRitual.new(2, {"block":1}, 30),
]
