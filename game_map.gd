extends Node2D

@onready var tilemap = $TileMapLayer
@onready var shop = $ShopCanvas
@onready var path: Path2D = $Path2D
@onready var wave_label: Label = $CanvasLayer/HBoxContainer3/WaveLabel
@onready var player = $Player

var money_factory_scene = preload("res://money_factory.tscn")
var placing_money_factory : bool = false

var tower_scene = preload("res://Tower.tscn")
var long_tower_scene = preload("res://SniperTower.tscn")
var basic_tower_scene = preload("res://Tower.tscn")
var placing_tower: bool = false
var distance_apart: int = 5
var tower_id: int = 1

var enemy_scenes := {
	"standard": preload("res://Mobs/enemy.tscn"),
	"weak": preload("res://Mobs/enemy_weak.tscn"),
	"strong": preload("res://Mobs/enemy_strong.tscn")
}

var waves_data: Array = []
var total_waves: int = 0
var current_wave: int = 0
var is_wave_flow_running: bool = false
var is_game_over: bool = false

# For getting sprite texture size and similar
# Do not add or modify
var _tower_dummy = tower_scene.instantiate()

# TileMapLayer terrain ID for path tiles
const PATH_TILE_ID = 0
const WAVES_FILE_PATH = "res://waves.json"
const MAX_WAVES = 20
#Stops Main meniu music once game starts
func _ready() -> void:
	if MeniuMusic:
		MeniuMusic.stop()
		GameMusic.play()

	_load_waves_data()
	if total_waves > 0:
		current_wave = 1
		_update_wave_label()
		_start_wave_flow()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		var selected = shop.selected_tower_type 
		
		for tower in get_tree().get_nodes_in_group("towers"):
			if tower.has_method("set_range_visible"):
				tower.set_range_visible(false)
		
		if selected != "":
			if selected == "Tower":
				tower_scene = basic_tower_scene
				place_tower()
			elif selected == "Sniper":
				tower_scene = long_tower_scene
				place_tower()
			elif selected == "Money":
				place_money_factory()
				 

func place_money_factory() -> void:
	var mouse_pos = get_global_mouse_position()
	
	if is_tower_already_at(mouse_pos) or is_over_path(mouse_pos):
		print("Cannot place money factory at ", mouse_pos)
		return
	
	var factory = money_factory_scene.instantiate()
	factory.position = mouse_pos
	factory.name = "MoneyFactory#" + str(tower_id)
	factory.add_to_group("towers")
	tower_id += 1
	add_child(factory)
	print("Placed money factory at ", mouse_pos)
	Currency.spend_coins(shop.price)
	shop.price = 0
	shop.selected_tower_type = ""
	

func place_tower() -> void:
	var mouse_pos = get_global_mouse_position()
	
	if is_tower_already_at(mouse_pos) or is_over_path(mouse_pos):
		print("Cannot place tower at ", mouse_pos)
		return
	
	var tower = tower_scene.instantiate()
	tower.position = mouse_pos
	tower.name = "Tower#" + str(tower_id)
	tower_id += 1
	add_child(tower)
	print("Placed tower at ", mouse_pos)
	Currency.spend_coins(shop.price)
	shop.price = 0
	shop.selected_tower_type = ""

func is_tower_already_at(pos: Vector2) -> bool:
	for child in get_children():
		print(child)
		if child.is_in_group("towers"):
			var sprite = child.get_node("Sprite2D")
			var sprite_size = sprite.texture.get_size()
			var radius = max(sprite_size.x, sprite_size.y) + distance_apart
			if child.position.distance_to(pos) < radius:
				return true
	return false

func _get_tower_footprint_polygon(tower_pos: Vector2) -> PackedVector2Array:
	var area: Area2D = _tower_dummy.get_node_or_null("Area2D")
	if area == null:
		return PackedVector2Array()

	var shape_node: CollisionShape2D = area.get_node_or_null("CollisionShape2D")
	if shape_node == null or shape_node.shape == null:
		return PackedVector2Array()

	var shape_transform = Transform2D(0.0, tower_pos) * area.transform * shape_node.transform
	var polygon := PackedVector2Array()

	if shape_node.shape is RectangleShape2D:
		var rect_shape = shape_node.shape as RectangleShape2D
		var half_size = rect_shape.size / 2.0
		var local_points = [
			Vector2(-half_size.x, -half_size.y),
			Vector2(half_size.x, -half_size.y),
			Vector2(half_size.x, half_size.y),
			Vector2(-half_size.x, half_size.y)
		]
		for point in local_points:
			polygon.append(shape_transform * point)
		return polygon

	if shape_node.shape is CircleShape2D:
		var circle_shape = shape_node.shape as CircleShape2D
		var sample_count = 16
		for i in sample_count:
			var angle = TAU * float(i) / float(sample_count)
			var local_point = Vector2(cos(angle), sin(angle)) * circle_shape.radius
			polygon.append(shape_transform * local_point)
		return polygon

	return PackedVector2Array()

func is_over_path(tower_pos: Vector2) -> bool:
	if tilemap.tile_set == null:
		return false

	var footprint = _get_tower_footprint_polygon(tower_pos)
	if footprint.is_empty():
		return false

	var min_point = Vector2(INF, INF)
	var max_point = Vector2(-INF, -INF)
	for point in footprint:
		min_point.x = min(min_point.x, point.x)
		min_point.y = min(min_point.y, point.y)
		max_point.x = max(max_point.x, point.x)
		max_point.y = max(max_point.y, point.y)

	var min_cell = tilemap.local_to_map(tilemap.to_local(min_point))
	var max_cell = tilemap.local_to_map(tilemap.to_local(max_point))
	var half_tile = Vector2(tilemap.tile_set.tile_size) / 2.0

	for x in range(min_cell.x, max_cell.x + 1):
		for y in range(min_cell.y, max_cell.y + 1):
			var cell = Vector2i(x, y)
			var tile_data = tilemap.get_cell_tile_data(cell)
			if tile_data == null or tile_data.terrain != PATH_TILE_ID:
				continue

			var tile_center = tilemap.to_global(tilemap.map_to_local(cell))
			var tile_polygon := PackedVector2Array([
				tile_center + Vector2(-half_tile.x, -half_tile.y),
				tile_center + Vector2(half_tile.x, -half_tile.y),
				tile_center + Vector2(half_tile.x, half_tile.y),
				tile_center + Vector2(-half_tile.x, half_tile.y)
			])

			if not Geometry2D.intersect_polygons(footprint, tile_polygon).is_empty():
				return true

	return false

func _load_waves_data() -> void:
	waves_data.clear()
	total_waves = 0

	if not FileAccess.file_exists(WAVES_FILE_PATH):
		push_error("waves.json file was not found")
		return

	var waves_file = FileAccess.open(WAVES_FILE_PATH, FileAccess.READ)
	if waves_file == null:
		push_error("Failed to open waves.json")
		return

	var json_text = waves_file.get_as_text()
	var parsed = JSON.parse_string(json_text)
	if typeof(parsed) != TYPE_ARRAY:
		push_error("waves.json root must be an array")
		return

	waves_data = parsed
	total_waves = min(MAX_WAVES, waves_data.size())

	if total_waves == 0:
		push_warning("No waves found in waves.json")
	elif waves_data.size() < MAX_WAVES:
		push_warning("waves.json has fewer than 20 waves")

func _start_wave_flow() -> void:
	if is_wave_flow_running:
		return
	is_wave_flow_running = true
	call_deferred("_run_wave_flow")

func _run_wave_flow() -> void:
	for wave_number in range(1, total_waves + 1):
		if _has_game_over():
			break

		current_wave = wave_number
		_update_wave_label()
		await _spawn_wave(wave_number)
		await _wait_until_wave_is_clear()

	is_wave_flow_running = false

func _spawn_wave(wave_number: int) -> void:
	if wave_number <= 0 or wave_number > waves_data.size():
		return

	var wave_data = waves_data[wave_number - 1] as Dictionary
	var wave_enemies = wave_data.get("enemies", []) as Array

	for group in wave_enemies:
		var group_data = group as Dictionary
		var enemy_type = str(group_data.get("type", "standard"))
		var count = int(group_data.get("count", 0))
		var delay_seconds = maxf(float(group_data.get("delay", 0.0)), 0.0)

		for i in range(count):
			if _has_game_over():
				return

			_spawn_enemy(enemy_type)
			if delay_seconds > 0.0:
				await get_tree().create_timer(delay_seconds).timeout

func _spawn_enemy(enemy_type: String) -> void:
	var enemy_scene: PackedScene = enemy_scenes.get(enemy_type)
	if enemy_scene == null:
		push_warning("Unknown enemy type: " + enemy_type)
		return

	var path_follow := PathFollow2D.new()
	path_follow.loop = false
	path.add_child(path_follow)

	var enemy = enemy_scene.instantiate()
	path_follow.add_child(enemy)
	if enemy.has_signal("tree_exited"):
		enemy.tree_exited.connect(path_follow.queue_free, CONNECT_ONE_SHOT)

func _wait_until_wave_is_clear() -> void:
	while true:
		if _has_game_over():
			return

		if get_tree().get_nodes_in_group("mobs").is_empty():
			return

		await get_tree().process_frame

func _has_game_over() -> bool:
	if is_game_over:
		return true

	if player != null and player.has_method("get"):
		var hp_value = player.get("hp")
		if typeof(hp_value) == TYPE_INT and hp_value <= 0:
			is_game_over = true

	return is_game_over

func _update_wave_label() -> void:
	if wave_label:
		wave_label.text = str(current_wave) + "/" + str(total_waves)
	
