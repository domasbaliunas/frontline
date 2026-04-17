extends Node2D

@onready var range_area: Area2D = $Tower
@onready var range_shape_node: CollisionShape2D = $Tower/CollisionShape2D
@onready var range_visual: Polygon2D = $RangeCircle
@onready var tower_sprite: Sprite2D = $Sprite2D
@onready var area = $Area2D

@export var attack_speed: float = 0.75
@export var tower_type: String = "normal"

@export_group("Damage")
@export var base_damage: float = 25.0
@export_range(0, 999, 1, "or_greater") var critical_shot_interval: int = 3
@export_range(1.0, 10.0, 0.1) var critical_damage_multiplier: float = 2.0

var projectile_scene: PackedScene = preload("res://scenes/core/Projectile.tscn")

var attack_timer: Timer
var range_value: float
var range_shape: CircleShape2D
var shots_fired: int = 0
@export var cost: int = 100  

var is_preview: bool = false
var is_placement_valid: bool = true

func _ready() -> void:
	if range_shape_node and range_shape_node.shape is CircleShape2D:
		range_shape = (range_shape_node.shape as CircleShape2D).duplicate()
		range_shape_node.shape = range_shape
		range_value = range_shape.radius
	
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / maxf(attack_speed, 0.001)
	attack_timer.one_shot = false
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)
	
	if area:
		area.input_event.connect(_on_click_area_input)
	
	update_range_visual()
	
	if is_preview:
		if range_visual: range_visual.visible = true
		attack_timer.paused = true
	else:
		if range_visual: range_visual.visible = false
		attack_timer.start()

func _process(_delta: float) -> void:
	if is_preview:
		update_placement_visuals()

func update_placement_visuals():
	if not range_visual or not tower_sprite: return
	
	if is_placement_valid:
		range_visual.color = Color(0, 1, 0, 0.2)
		tower_sprite.modulate = Color(1, 1, 1, 1)
	else:
		range_visual.color = Color(1, 0, 0, 0.3)
		tower_sprite.modulate = Color(1, 0.2, 0.2, 1)

func set_range(new_range: float) -> void:
	range_value = new_range
	if range_shape:
		range_shape.radius = new_range
	update_range_visual()

func update_range_visual():
	if not range_visual:
		return
	
	var points = PackedVector2Array()
	var segments = 64
	
	for i in segments:
		var angle = TAU * float(i) / float(segments)
		points.append(Vector2(cos(angle), sin(angle)) * range_value)
	
	range_visual.polygon = points

func set_preview_mode(enabled: bool):
	is_preview = enabled
	
	if range_visual:
		range_visual.visible = enabled
		update_placement_visuals()
	
	if attack_timer:
		attack_timer.paused = enabled
	
	if not enabled:
		if tower_sprite: tower_sprite.modulate = Color(1, 1, 1, 1)
		if range_visual: range_visual.color = Color(1, 0.6, 0.6, 0.2)
		if not is_in_group("towers"):
			add_to_group("towers")

func set_range_visible(visible: bool):
	if range_visual:
		range_visual.visible = visible
		if not is_preview:
			range_visual.color = Color(0, 0, 0, 0.2)

func _on_attack_timer_timeout():
	var target = get_target()
	if target != null:
		attack(target)

func get_target():
	if not range_area: return null
	var closest = null
	var closest_dist = INF
	
	for body in range_area.get_overlapping_bodies():
		if not body.is_in_group("mobs"):
			continue
			
		var dist = global_position.distance_to(body.global_position)
		if dist < closest_dist:
			closest = body
			closest_dist = dist
			
	return closest

func attack(target):
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
	proj.tower_type = tower_type
	
	get_tree().current_scene.add_child(proj)

func _on_click_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var build_manager = get_tree().get_first_node_in_group("build_manager")
		if build_manager and build_manager.current_preview != null:
			return
		
		if not is_preview:
			for tower in get_tree().get_nodes_in_group("towers"):
				if tower.has_method("set_range_visible"):
					tower.set_range_visible(false)
			
			if range_visual:
				range_visual.color = Color(0, 0, 0, 0.2)
				range_visual.visible = true
		
		var menu = get_tree().get_first_node_in_group("tower_menu")
		if menu:
			menu.open_menu(self)
