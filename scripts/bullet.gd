class_name Bullet
extends Node2D

var target: Enemy
var damage: int = 1
var speed: float = 500.0
var slow_factor: float = 1.0
var slow_time: float = 0.0
var color: Color = Color.YELLOW

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
	var to_target := target.global_position - global_position
	if to_target.length() <= speed * delta:
		if slow_time > 0.0:
			target.apply_slow(slow_factor, slow_time)
		target.take_damage(damage)
		queue_free()
	else:
		global_position += to_target.normalized() * speed * delta

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, color)