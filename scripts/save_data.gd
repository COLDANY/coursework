class_name SaveData

const PATH := "user://save.cfg"

static func load_best() -> int:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return 0
	return cfg.get_value("game", "best_score", 0)

static func save_best(score: int) -> bool:
	if score <= load_best():
		return false
	var cfg := ConfigFile.new()
	cfg.set_value("game", "best_score", score)
	cfg.save(PATH)
	return true
