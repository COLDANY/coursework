class_name Enemy
extends PathFollow2D

signal reached_end
signal died(reward: int)

var speed: float = 100.0
var max_hp: int = 3
var hp: int = 3
var reward: int = 10
var color: Color = Color.RED
var slow_factor: float = 1.0
var slow_left: float = 0.0
var dead: bool = false

func setup(data: Dictionary) -> void:
	speed = data.speed
	max_hp = data.hp
	hp = data.hp
	reward = data.reward
	color = data.color

func _ready() -> void:
	add_to_group("enemies")
	loop = false
	rotates = false

func _process(delta: float) -> void:
	if slow_left > 0.0:
		slow_left -= delta
		if slow_left <= 0.0:
			slow_factor = 1.0
			queue_redraw()
	progress += speed * slow_factor * delta
	if progress_ratio >= 1.0 and not dead:
		dead = true
		reached_end.emit()
		queue_free()

func take_damage(amount: int) -> void:
	if dead:
		return
	hp -= amount
	queue_redraw()
	if hp <= 0:
		dead = true
		died.emit(reward)
		queue_free()

func apply_slow(factor: float, duration: float) -> void:
	slow_factor = factor
	slow_left = duration
	queue_redraw()

func _draw() -> void:
	var body := color if slow_factor >= 1.0 else color.lerp(Color.CYAN, 0.6)
	draw_circle(Vector2.ZERO, 14, body)
	var ratio := float(hp) / float(max_hp)
	draw_rect(Rect2(-14, -24, 28, 4), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(-14, -24, 28 * ratio, 4), Color.LIME_GREEN)