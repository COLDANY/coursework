class_name HUD
extends CanvasLayer

signal tower_selected(type: String)
signal restart_pressed
signal menu_pressed

var info_label: Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	info_label = Label.new()
	info_label.position = Vector2(20, 10)
	info_label.add_theme_font_size_override("font_size", 28)
	add_child(info_label)

	var bar := HBoxContainer.new()
	bar.position = Vector2(20, 620)
	bar.add_theme_constant_override("separation", 20)
	add_child(bar)

	var group := ButtonGroup.new()
	var first := true
	for type in GameData.TOWERS:
		var d: Dictionary = GameData.TOWERS[type]
		var b := Button.new()
		b.text = "%s (%d)" % [d.name, d.cost]
		b.toggle_mode = true
		b.button_group = group
		b.custom_minimum_size = Vector2(260, 80)
		b.add_theme_font_size_override("font_size", 24)
		b.pressed.connect(func(): tower_selected.emit(type))
		bar.add_child(b)
		if first:
			b.button_pressed = true
			first = false

func update_info(gold: int, lives: int, wave: int, waves_total: int) -> void:
	info_label.text = "Золото: %d    Жизни: %d    Волна: %d/%d" % [gold, lives, wave, waves_total]

func show_result(text: String, subtitle: String = "") -> void:
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.7)
	shade.size = Vector2(1280, 720)
	add_child(shade)

	_result_label(shade, text, 180, 64)
	_result_label(shade, subtitle, 290, 32)
	_result_button(shade, "Заново", Vector2(340, 420), func(): restart_pressed.emit())
	_result_button(shade, "В меню", Vector2(640, 420), func(): menu_pressed.emit())

func _result_label(parent: Node, text: String, y: float, font_size: int) -> void:
	var l := Label.new()
	l.text = text
	l.position = Vector2(0, y)
	l.size = Vector2(1280, 100)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", font_size)
	parent.add_child(l)

func _result_button(parent: Node, text: String, pos: Vector2, action: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.position = pos
	b.custom_minimum_size = Vector2(300, 90)
	b.add_theme_font_size_override("font_size", 32)
	b.pressed.connect(action)
	parent.add_child(b)