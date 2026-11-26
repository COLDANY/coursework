class_name Tower
extends Node2D

@export var attack_range: float = 180.0
@export var damage: int = 1
@export var fire_rate: float = 2.0

var cooldown: float = 0.0
var current_target: Enemy = null

func _process(delta: float) -> void:
	cooldown -= delta
	if not _is_valid_target(current_target):
		current_target = _find_target()
	if _is_valid_target(current_target) and cooldown <= 0.0:
		_shoot(current_target)
		cooldown = 1.0 / fire_rate
func _is_valid_target(e) -> bool:
	return is_instance_valid(e) and global_position.distance_to(e.global_position) <= attack_range
func _find_target() -> Enemy:
	var best: Enemy = null
	for node in get_tree().get_nodes_in_group("enemies"):
		var e := node as Enemy
		if _is_valid_target(e) and (best == null or e.progress > best.progress):
			best = e
	return best

func _shoot(target: Enemy) -> void:
	var b := Bullet.new()
	b.target = target
	b.damage = damage
	get_tree().current_scene.add_child(b)
	b.global_position = global_position

func _draw() -> void:
	draw_rect(Rect2(-18, -18, 36, 36), Color.ROYAL_BLUE)
	draw_arc(Vector2.ZERO, attack_range, 0, TAU, 64, Color(1, 1, 1, 0.25), 2.0)