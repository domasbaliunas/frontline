extends Control

@onready var health_bar: ProgressBar = $ProgressBar
@onready var value_label: Label = $ValueLabel

func _ready() -> void:
	hide()

func show_boss_health(current_hp: float, max_hp: float) -> void:
	show()
	update_boss_health(current_hp, max_hp)

func update_boss_health(current_hp: float, max_hp: float) -> void:
	health_bar.max_value = max_hp
	health_bar.value = max(current_hp, 0.0)
	value_label.text = str(int(max(current_hp, 0.0))) + " / " + str(int(max_hp))

func hide_boss_health() -> void:
	hide()
