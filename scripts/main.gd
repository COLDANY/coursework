extends Node2D

const ENEMY_SCENE := preload("res://scenes/enemy.tscn")
const PATH_POINTS := [
	Vector2(0, 360), Vector2(300, 360), Vector2(300, 150),
	Vector2(700, 150), Vector2(700, 550), Vector2(1280, 550),
]

@onready var path: Path2D = $Path
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	var curve := Curve2D.new()
	for p in PATH_POINTS:
		curve.add_point(p)
	path.curve = curve
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.start()
	
	var tower := Tower.new()
	tower.position = Vector2(500, 260)
	add_child(tower)

func _spawn_enemy() -> void:
	var enemy := ENEMY_SCENE.instantiate()
	path.add_child(enemy)

func _draw() -> void:
	draw_polyline(PackedVector2Array(PATH_POINTS), Color.DARK_GRAY, 40.0)
