extends CharacterBody2D
class_name Enemy

const DAMAGE_POPUP_SCRIPT = preload("res://scripts/ui/damage_popup.gd")

@export var speed: float = 75
@export var max_health: float = 100
@export var coin_reward: int = 10

@export var resistances: Dictionary = {
	"normal": 0.0,
	"sniper": 0.0
}

@export_group("Damage Popup")
@export var damage_popup_offset: Vector2 = Vector2(0, -20)
@export var damage_popup_random_offset: Vector2 = Vector2(8, 4)
@export var damage_popup_z_index: int = 200
@export var damage_popup_lifetime: float = 0.55
@export var damage_popup_rise_speed: float = 85.0
@export var damage_popup_font_size: int = 24
@export var damage_popup_normal_color: Color = Color.WHITE
@export var damage_popup_critical_color: Color = Color(1.0, 0.9, 0.2)
@export var damage_popup_kill_color: Color = Color(1.0, 0.2, 0.2)

var health: float
var path_follow: PathFollow2D

func _ready() -> void:
	health = max_health
	path_follow = get_parent() as PathFollow2D
	add_to_group("mobs")

func _process(delta: float) -> void:
	move_along_path(delta)
	update_sprite_scale()

func move_along_path(delta: float):
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 1.0:
		queue_free()

var min_scale = 0.5
var max_scale = 1.0

func update_sprite_scale():
	var health_ratio = clamp(health / max_health, 0.0, 1.0)
	var current_scale = min_scale + (health_ratio * (max_scale - min_scale))
	scale = Vector2(current_scale, current_scale)

func take_damage(amount: float, is_critical_hit: bool = false, tower_type: String = "normal") -> void:
	if health <= 0 or amount <= 0:
		return

	var resistance := 0.0
	if resistances.has(tower_type):
		resistance = resistances[tower_type]

	var final_damage := amount * (1.0 - resistance)

	health -= final_damage
	var is_killing_blow := health <= 0
	_spawn_damage_popup(final_damage, is_killing_blow, is_critical_hit)
	print("Mob health:", health)

	if is_killing_blow:
		die()

func _spawn_damage_popup(amount: float, is_killing_blow: bool, is_critical_hit: bool) -> void:
	if get_tree() == null or get_tree().current_scene == null:
		return

	var popup: DamagePopup = DAMAGE_POPUP_SCRIPT.new()
	var random_offset := Vector2(
		randf_range(-damage_popup_random_offset.x, damage_popup_random_offset.x),
		randf_range(-damage_popup_random_offset.y, damage_popup_random_offset.y)
	)
	popup.global_position = global_position + damage_popup_offset + random_offset
	popup.z_index = damage_popup_z_index
	popup.lifetime = damage_popup_lifetime
	popup.rise_speed = damage_popup_rise_speed
	popup.font_size = damage_popup_font_size
	popup.normal_color = damage_popup_normal_color
	popup.critical_color = damage_popup_critical_color
	popup.kill_color = damage_popup_kill_color
	popup.setup(int(round(amount)), is_killing_blow, is_critical_hit)
	get_tree().current_scene.add_child(popup)
		
func die() -> void:
	print("Mob died!")
	Currency.add_coins(coin_reward)
	queue_free()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):  
		take_damage(25)
