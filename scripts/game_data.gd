class_name GameData

const START_GOLD := 100
const START_LIVES := 10

const ENEMIES := {
	"basic": {"speed": 100.0, "hp": 3, "reward": 10, "color": Color.RED},
	"fast": {"speed": 180.0, "hp": 2, "reward": 8, "color": Color.ORANGE},
}

const TOWERS := {
	"basic": {"name": "Стрелок", "cost": 50, "attack_range": 180.0, "damage": 1,
		"rate": 2.0, "slow": 1.0, "slow_time": 0.0, "color": Color.ROYAL_BLUE},
	"frost": {"name": "Заморозка", "cost": 70, "attack_range": 150.0, "damage": 1,
		"rate": 1.0, "slow": 0.5, "slow_time": 1.5, "color": Color.CYAN},
}

const WAVES := [
	[{"kind": "basic", "num": 6, "interval": 1.2}],
	[{"kind": "basic", "num": 8, "interval": 1.0}],
	[{"kind": "basic", "num": 5, "interval": 1.0}, {"kind": "fast", "num": 5, "interval": 0.8}],
	[{"kind": "fast", "num": 8, "interval": 0.7}, {"kind": "basic", "num": 6, "interval": 1.0}],
	[{"kind": "basic", "num": 10, "interval": 0.8}, {"kind": "fast", "num": 10, "interval": 0.6}],
]