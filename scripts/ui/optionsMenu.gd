extends Control

@onready var slider = $MusicSlider
@onready var mute_btn = $MuteButton
@onready var screen_cb = $ScreenAnimationsCheckBox
@onready var entity_cb = $EntitiesAnimationsCheckBox
@onready var damage_cb = $DamagePopupCheckBox
@onready var wave_cb = $WavePopupCheckBox


func _ready():
	slider.value = MeniuMusic.music_volume
	slider.value = GameMusic.music_volume
	slider.editable = !MeniuMusic.muted
	slider.editable = !GameMusic.muted
	screen_cb.button_pressed = Settings.screen_animations
	entity_cb.button_pressed = Settings.entity_animations
	damage_cb.button_pressed = Settings.damage_popup
	wave_cb.button_pressed = Settings.wave_popup
	_update_mute_button_text()

func _on_music_slider_value_changed(value: float) -> void:
	MeniuMusic.set_volume(value)
	GameMusic.set_volume(value)
	print(value)

func _on_mute_button_pressed() -> void:
	MeniuMusic.toggle_mute(!MeniuMusic.muted)
	GameMusic.toggle_mute(!GameMusic.muted)
	slider.editable = !MeniuMusic.muted
	slider.editable = !GameMusic.muted
	_update_mute_button_text()

func _update_mute_button_text():
	mute_btn.text = "Unmute" if MeniuMusic.muted else "Mute"

func _on_back_button_pressed() -> void:
	if get_tree().current_scene.name == "OptionsMenu": 
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	else:
		self.visible = false

func get_state(value: bool) -> String:
	return "ON" if value else "OFF"

func _on_screen_animations_check_box_toggled(pressed) -> void:
	Settings.screen_animations = pressed
	print(get_tree().get_nodes_in_group("screen_animations").size())
	for node in get_tree().get_nodes_in_group("screen_animations"):
		var anim = node.get_node_or_null("AnimationPlayer")
		if anim:
			if pressed:
				anim.play()
			else:
				anim.pause()

func _on_entities_animations_check_box_toggled(pressed) -> void:
	Settings.entity_animations = pressed


func _on_damage_popup_check_box_toggled(pressed) -> void:
	Settings.damage_popup = pressed


func _on_wave_popup_check_box_toggled(pressed) -> void:
	Settings.wave_popup = pressed
