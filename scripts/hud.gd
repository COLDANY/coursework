class_name HUD
extends CanvasLayer

signal tower_selected(type: String)
signal restart_pressed

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

func show_result(text: String) -> void:
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.7)
	shade.size = Vector2(1280, 720)
	add_child(shade)

	var label := Label.new()
	label.text = text
	label.size = Vector2(1280, 100)
	label.position = Vector2(0, 220)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 64)
	shade.add_child(label)

	var btn := Button.new()
	btn.text = "Заново"
	btn.custom_minimum_size = Vector2(300, 90)
	btn.position = Vector2(490, 400)
	btn.add_theme_font_size_override("font_size", 32)
	btn.pressed.connect(func(): restart_pressed.emit())
	shade.add_child(btn)