extends Node2D
class_name DamagePopup

@export var lifetime: float = 0.55
@export var rise_speed: float = 85.0
@export var font_size: int = 24
@export var normal_color: Color = Color.WHITE
@export var critical_color: Color = Color(1.0, 0.9, 0.2)
@export var kill_color: Color = Color(1.0, 0.2, 0.2)

var _elapsed: float = 0.0
var _damage_text: String = ""
var _text_color: Color = Color.WHITE

func setup(damage: int, killed_enemy: bool, critical_hit: bool = false) -> void:
	_damage_text = str(max(damage, 0))
	if critical_hit:
		_text_color = critical_color
	else:
		_text_color = kill_color if killed_enemy else normal_color
	queue_redraw()

func _process(delta: float) -> void:
	_elapsed += delta
	position += Vector2.UP * rise_speed * delta
	queue_redraw()

	if _elapsed >= lifetime:
		queue_free()

func _draw() -> void:
	if _damage_text.is_empty():
		return

	var font := ThemeDB.fallback_font
	if font == null:
		return

	var alpha := 1.0 - clampf(_elapsed / lifetime, 0.0, 1.0)
	var text_size := font.get_string_size(_damage_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var color := _text_color
	color.a = alpha

	# draw_string uses the baseline position, so we offset by ascent.
	var baseline := font.get_ascent(font_size) * 0.5
	draw_string(font, Vector2(-text_size.x * 0.5, baseline), _damage_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)
