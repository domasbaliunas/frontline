extends Node2D

var speed: float = 1000.0
var target: Enemy = null
var damage: float = 25.0
var is_critical_hit: bool = false
var tower_type: String = "normal"

const TRAVEL_TIME: float = 0.2

var start_position: Vector2
var elapsed_time: float = 0.0

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:

	if target == null or not is_instance_valid(target) \
	or not target.is_in_group("mobs"):
		queue_free()
		return

	elapsed_time += delta

	var target_position = target.global_position
	var t = min(elapsed_time / TRAVEL_TIME, 1.0)

	if Settings.entity_animations:
		global_position = start_position.lerp(target_position, t)
	else:
		if t >= 1.0:
			global_position = target_position


	if t >= 1.0:
		if is_instance_valid(target):
			target.take_damage(_determine_damage(target), is_critical_hit, tower_type)
		queue_free()

func _determine_damage(_target: Enemy) -> float:
	return maxf(damage, 0.0)
