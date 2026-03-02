extends Node2D

@onready var range_area: Area2D = $Tower
@export var attack_speed = 0.75
var projectile_scene: PackedScene = preload("res://Projectile.tscn")

var attack_timer: Timer
var range_value: float

# Range by default is set by the value of CollisionShape2D. set_range function allows
# to change the range from default. This can be used if range upgrades would be implemented.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape_node = range_area.get_node("CollisionShape2D")
	if shape_node and shape_node.shape is CircleShape2D:
		range_value = shape_node.shape.radius

	add_to_group("towers", true)
	attack_timer = Timer.new()
	attack_timer.wait_time = 1 / attack_speed
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
		shape_node.shape.radius = range

func _on_attack_timer_timeout():
	var target = get_target()
	if target != null:
		attack(target)

# Only look for Mob nodes in the "mobs" group
func get_target() -> Mob:
	var closest: Mob = null
	var closest_dist = INF
	
	for body in range_area.get_overlapping_bodies():
		if not body.is_in_group("mobs"):
			continue
			
		var dist = global_position.distance_to(body.global_position)
		
		if dist < closest_dist:
			closest = body
			closest_dist = dist
			
	return closest
	
func attack(target: Mob):
	if projectile_scene == null:
		return
	var proj = projectile_scene.instantiate()
	proj.global_position = global_position
	proj.target = target
	get_tree().current_scene.add_child(proj)
