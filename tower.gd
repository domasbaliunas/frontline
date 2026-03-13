extends Node2D

@onready var range_area: Area2D = $Tower
@export var attack_speed: float = 0.75

@export_group("Damage")
@export var base_damage: float = 25.0
@export_range(0, 999, 1, "or_greater") var critical_shot_interval: int = 3
@export_range(1.0, 10.0, 0.1) var critical_damage_multiplier: float = 2.0

var projectile_scene: PackedScene = preload("res://Projectile.tscn")

var attack_timer: Timer
var range_value: float
var shots_fired: int = 0

# Range by default is set by the value of CollisionShape2D. set_range function allows
# to change the range from default. This can be used if range upgrades would be implemented.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape_node = range_area.get_node("CollisionShape2D")
	if shape_node and shape_node.shape is CircleShape2D:
		range_value = shape_node.shape.radius

	add_to_group("towers", true)
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / maxf(attack_speed, 0.001)
	attack_timer.one_shot = false
	attack_timer.autostart = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)
	
	# set_range(200)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_range(new_range: float) -> void:
	range_value = new_range
	var shape_node = range_area.get_node("CollisionShape2D")
	if shape_node and shape_node.shape is CircleShape2D:
		shape_node.shape.radius = new_range

func _on_attack_timer_timeout():
	var target = get_target()
	if target != null:
		attack(target)

# Only look for Mob nodes in the "mobs" group
func get_target() -> Enemy:
	var closest: Enemy = null
	var closest_dist = INF
	
	for body in range_area.get_overlapping_bodies():
		if not body.is_in_group("mobs"):
			continue
			
		var dist = global_position.distance_to(body.global_position)
		
		if dist < closest_dist:
			closest = body
			closest_dist = dist
			
	return closest
	
func attack(target: Enemy):
	if projectile_scene == null:
		return
	var proj = projectile_scene.instantiate()
	shots_fired += 1
	var is_critical_hit := critical_shot_interval > 0 and shots_fired % critical_shot_interval == 0
	var final_damage := base_damage
	if is_critical_hit:
		final_damage *= critical_damage_multiplier

	proj.global_position = global_position
	proj.target = target
	proj.damage = final_damage
	proj.is_critical_hit = is_critical_hit
	get_tree().current_scene.add_child(proj)
