extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const PATH_POINTS := [
	Vector2(0, 360), Vector2(300, 360), Vector2(300, 150),
	Vector2(700, 150), Vector2(700, 550), Vector2(1280, 550),
]
const SLOTS := [
	Vector2(150, 270), Vector2(200, 450), Vector2(400, 250), Vector2(600, 300),
	Vector2(800, 300), Vector2(800, 450), Vector2(1000, 450), Vector2(1000, 650),
]
const SLOT_SIZE := 44.0
const SLOT_TAP_RADIUS := 40.0

@onready var path: Path2D = $Path

var gold: int = GameData.START_GOLD
var lives: int = GameData.START_LIVES
var wave_number: int = 0
var selected_type: String = "basic"
var towers: Dictionary = {}  # индекс слота -> башня
var game_over: bool = false
var hud: HUD

func _ready() -> void:
	var curve := Curve2D.new()
	for p in PATH_POINTS:
		curve.add_point(p)
	path.curve = curve

	hud = HUD.new()
	add_child(hud)
	hud.tower_selected.connect(func(type: String): selected_type = type)
	hud.restart_pressed.connect(_restart)
	_update_hud()
	_run_waves()

func _draw() -> void:
	draw_polyline(PackedVector2Array(PATH_POINTS), Color.DARK_GRAY, 40.0)
	var half := SLOT_SIZE / 2.0
	for pos in SLOTS:
		draw_rect(Rect2(pos.x - half, pos.y - half, SLOT_SIZE, SLOT_SIZE), Color(0.35, 0.35, 0.35), false, 3.0)

func _unhandled_input(event: InputEvent) -> void:
	if game_over:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_try_build(get_global_mouse_position())

func _try_build(pos: Vector2) -> void:
	for i in SLOTS.size():
		if pos.distance_to(SLOTS[i]) > SLOT_TAP_RADIUS or towers.has(i):
			continue
		var data: Dictionary = GameData.TOWERS[selected_type]
		if gold < data.cost:
			return
		var tower := Tower.new()
		tower.setup(data)
		tower.position = SLOTS[i]
		add_child(tower)
		towers[i] = tower
		gold -= data.cost
		_update_hud()
		return

func _run_waves() -> void:
	for i in GameData.WAVES.size():
		wave_number = i + 1
		_update_hud()
		await get_tree().create_timer(3.0).timeout
		for group in GameData.WAVES[i]:
			for _n in group.num:
				if game_over:
					return
				_spawn_enemy(group.kind)
				await get_tree().create_timer(group.interval).timeout
		while get_tree().get_nodes_in_group("enemies").size() > 0:
			if game_over:
				return
			await get_tree().create_timer(0.5).timeout
	_end_game("Победа!")

func _spawn_enemy(kind: String) -> void:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.setup(GameData.ENEMIES[kind])
	enemy.reached_end.connect(_on_enemy_reached_end)
	enemy.died.connect(_on_enemy_died)
	path.add_child(enemy)

func _on_enemy_died(reward: int) -> void:
	gold += reward
	_update_hud()

func _on_enemy_reached_end() -> void:
	lives -= 1
	_update_hud()
	if lives <= 0:
		_end_game("Поражение")

func _end_game(text: String) -> void:
	if game_over:
		return
	game_over = true
	get_tree().paused = true
	hud.show_result(text)

func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _update_hud() -> void:
	hud.update_info(gold, lives, wave_number, GameData.WAVES.size())
