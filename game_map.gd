extends Node2D

@onready var tilemap = $TileMapLayer

var tower_scene = preload("res://Tower.tscn")
var placing_tower: bool = false
var distance_apart: int = 5
var tower_id: int = 1

# For getting sprite texture size and similar
# Do not add or modify
var _tower_dummy = tower_scene.instantiate()

# TileMapLayer terrain ID for path tiles
const PATH_TILE_ID = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("place_tower"):
		placing_tower = true
		place_tower()
		
func place_tower() -> void:
	var mouse_pos = get_global_mouse_position()
	var sprite = _tower_dummy.get_node("Sprite2D")
	var sprite_size = sprite.texture.get_size()
	
	if is_tower_already_at(mouse_pos) or is_over_path(mouse_pos, sprite_size):
		print("Cannot place tower at ", mouse_pos)
		return
	
	var tower = tower_scene.instantiate()
	tower.position = mouse_pos
	tower.name = "Tower#" + str(tower_id)
	tower_id += 1
	add_child(tower)
	print("Placed tower at ", mouse_pos)

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

func is_over_path(tower_pos: Vector2, sprite_size: Vector2) -> bool:
	# Get the corners of the sprite
	var half_size = sprite_size / 2
	var corners = [
		tower_pos + Vector2(-half_size.x, -half_size.y),  # top-left
		tower_pos + Vector2(half_size.x, -half_size.y),   # top-right
		tower_pos + Vector2(-half_size.x, half_size.y),   # bottom-left
		tower_pos + Vector2(half_size.x, half_size.y)     # bottom-right
	]

	for corner in corners:
		# Convert global position → local TileMapLayer space
		var local_corner = tilemap.to_local(corner)
		# Convert local position → tile coordinates
		var cell = tilemap.local_to_map(local_corner)
		# Get the TileData at this cell
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data == null:
			continue  # empty cell
		if tile_data.terrain == PATH_TILE_ID:
			return true  # one corner touches path → invalid placement

	return false  # all corners are clear
	
