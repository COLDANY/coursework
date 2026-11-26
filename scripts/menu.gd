extends Control

func _ready() -> void:
	size = Vector2(1280, 720)

	var bg := ColorRect.new()
	bg.color = Color(0.12, 0.14, 0.18)
	bg.size = Vector2(1280, 720)
	add_child(bg)

	_add_label("Tower Defense", Vector2(0, 120), 80)
	_add_label("Лучший счёт: %d" % SaveData.load_best(), Vector2(0, 250), 32)
	_add_button("Играть", Vector2(490, 340), func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	_add_button("Выход", Vector2(490, 460), func(): get_tree().quit())

func _add_label(text: String, pos: Vector2, font_size: int) -> void:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.size = Vector2(1280, 100)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", font_size)
	add_child(l)

func _add_button(text: String, pos: Vector2, action: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.position = pos
	b.custom_minimum_size = Vector2(300, 90)
	b.add_theme_font_size_override("font_size", 32)
	b.pressed.connect(action)
	add_child(b)
