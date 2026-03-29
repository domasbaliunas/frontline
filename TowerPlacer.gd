extends Node2D
var current_preview: Node2D = null
var selected_scene: PackedScene = null
var price: int = 0
var selected_tower_type: String = ""
var path: Path2D = null
const TOWER_RADIUS = 16
const PATH_CLEARANCE = 32

func _ready():
	add_to_group("build_manager")

func _get_path() -> Path2D:
	if path == null:
		path = get_tree().current_scene.find_child("Path2D", true, false)
	return path

func start_build(scene: PackedScene, cost: int, type_name: String):
	cancel_build()
	if not scene:
		return
	selected_scene = scene
	price = cost
	selected_tower_type = type_name
	current_preview = scene.instantiate()
	if current_preview.has_method("set_preview_mode"):
		current_preview.set_preview_mode(true)
	get_tree().current_scene.add_child(current_preview)

func cancel_build():
	if current_preview and current_preview.is_inside_tree():
		current_preview.queue_free()
	current_preview = null
	selected_scene = null
	selected_tower_type = ""
	price = 0

func _process(delta):
	if current_preview:
		current_preview.global_position = get_global_mouse_position()
		current_preview.modulate = Color(0,1,0,0.5) if can_place(current_preview.global_position) else Color(1,0,0,0.5)

func _unhandled_input(event):
	if current_preview == null:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			try_place()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_build()

func try_place():
	if not current_preview or not selected_scene:
		return
	if not can_place(current_preview.global_position):
		print("Cannot build here!")
		return
	if Currency.coins < price:
		print("Not enough coins!")
		return
	var tower_count = get_tree().get_nodes_in_group("towers").size()
	
	var tower = selected_scene.instantiate()
	tower.global_position = current_preview.global_position
	tower.name = "%s_%d" % [selected_tower_type, tower_count]  
	if tower.has_method("set_preview_mode"):
		tower.set_preview_mode(false)
	get_tree().current_scene.add_child(tower)
	
	Currency.spend_coins(price)
	cancel_build()

func can_place(pos: Vector2) -> bool:
	for tower in get_tree().get_nodes_in_group("towers"):
		if not tower.has_method("set_preview_mode"):
			continue
		if tower.global_position.distance_to(pos) < TOWER_RADIUS * 2:
			return false
	if is_too_close_to_path(pos):
		return false
	return true

func is_too_close_to_path(pos: Vector2) -> bool:
	var p = _get_path()
	if p == null or p.curve == null:
		return false
	var local_pos = p.to_local(pos)
	var closest = p.curve.get_closest_point(local_pos)
	return closest.distance_to(local_pos) < PATH_CLEARANCE
