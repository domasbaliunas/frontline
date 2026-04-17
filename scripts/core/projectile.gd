extends Node2D

var speed: float = 1000.0
var target: Enemy = null
var damage: float = 25.0
var is_critical_hit: bool = false
var tower_type: String = "normal"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target) \
		or not target.is_in_group("mobs"):
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta

	if global_position.distance_to(target.global_position) < 10:
		target.take_damage(_determine_damage(target), is_critical_hit, tower_type)
		queue_free()
		
func _determine_damage(_target: Enemy) -> float:
	return maxf(damage, 0.0)
