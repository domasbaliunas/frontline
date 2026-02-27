extends Node2D

var speed = 1000
var target: Mob = null

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target) \
		or not target.is_in_group("mobs"):
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta

	if global_position.distance_to(target.global_position) < 10:
		queue_free()
		target.take_damage(_determine_damage(target))
		
# To be able to change damage based on enemy type
func _determine_damage(target: Mob) -> int:
	return 10
