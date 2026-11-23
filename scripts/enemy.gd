class_name Enemy
extends PathFollow2D

signal reached_end
signal died

@export var speed: float = 100.0
@export var max_hp: int = 3

var hp: int

func _ready() -> void:
	hp = max_hp
	loop = false
	rotates = false

func _process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		reached_end.emit()
		queue_free()

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		died.emit()
		queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14, Color.RED)