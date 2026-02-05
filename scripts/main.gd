extends Node2D

const GRID_W := 4
const GRID_H := 4
const TILE_SIZE := 96

const GRID_ORIGIN := Vector2(64, 64)

# Each grid cell maps to a Tile object
var tiles: Dictionary = {}

var player_cell := Vector2i(0, 0)

enum Facing { UP, DOWN, LEFT, RIGHT}
var facing: Facing = Facing.DOWN

# import the font for the Question mark tiles
@onready var question_font: Font = load("res://assets/fonts/consola.ttf")
var question_font_size := 32

# helper function for player facing direction
func _facing_dir() -> Vector2i:
	match facing:
		Facing.UP: return Vector2i(0, -1)
		Facing.DOWN: return Vector2i(0, 1)
		Facing.LEFT: return Vector2i(-1, 0)
		Facing.RIGHT: return Vector2i(1, 0)
	return Vector2i.ZERO

# helper function for finding the square "in front"
func _cell_in_front() -> Vector2i:
	return player_cell + _facing_dir()

# function for the action button
func _try_action() -> void:
	var target := _cell_in_front()

	if not _in_bounds(target):
		print("Nothing there.")
		return

	var t := _get_tile(target)
	if t != null and t.interactive:
		print("Action used on interactive tile at: ", target)
	else:
		print("No interaction at: ", target)

	queue_redraw()

# Function for building attributes of tiles in the grid
func _build_tiles() -> void:
	tiles.clear()
	
	# Create a Tile object for every cell in the 4x4 grid
	for y in range(GRID_H):
		for x in range(GRID_W):
			var cell := Vector2i(x,y)
			tiles[cell] = Tile.new(cell)

	# Mark specific cells as interactive (and optionally solid)
	# If you want them impassable, set solid=true
	_set_question_tile(Vector2i(1,1), true)
	_set_question_tile(Vector2i(2,3), true)

# helper function for setting a tile as a question tile
func _set_question_tile(cell: Vector2i, make_solid: bool) -> void:
	if not tiles.has(cell):
		return
	var t: Tile = tiles[cell]
	t.interactive = true
	t.marker = "?"
	t.solid = make_solid

# helper function for setting a tile as in-bounds
func _in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_W and cell.y >= 0 and cell.y < GRID_H

# helper function setting up tiles
func _get_tile(cell: Vector2i) -> Tile:
	return tiles.get(cell, null)
	
# help function for setting a tile as solid
func _is_solid(cell: Vector2i) -> bool:
	var t := _get_tile(cell)
	return t != null and t.solid

func _ready() -> void:
	_build_tiles()
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	var move := Vector2i.ZERO

	if event.is_action_pressed("action"):
		_try_action()
		return
	if event.is_action_pressed("move_up"):
		move = Vector2i(0, -1)
		facing = Facing.UP
	elif event.is_action_pressed("move_down"):
		move = Vector2i(0, 1)
		facing = Facing.DOWN
	elif event.is_action_pressed("move_left"):
		move = Vector2i(-1, 0)
		facing = Facing.LEFT
	elif event.is_action_pressed("move_right"):
		move = Vector2i(1, 0)
		facing = Facing.RIGHT
	else:
		return

	var next := player_cell + move
	next.x = clamp(next.x, 0, GRID_W - 1)
	next.y = clamp(next.y, 0, GRID_H - 1)

	if next != player_cell and not _is_solid(next):
		player_cell = next
	queue_redraw()

func _draw() -> void:
	# Grid
	for y in range(GRID_H):
		for x in range(GRID_W):
			var pos := GRID_ORIGIN + Vector2(x, y) * TILE_SIZE
			var rect := Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE))

			draw_rect(rect, Color(0.15, 0.15, 0.15), true)
			draw_rect(rect, Color(0.4, 0.4, 0.4), false, 2)

	# Player
	var ppos := GRID_ORIGIN + Vector2(player_cell) * TILE_SIZE
	var prect := Rect2(ppos + Vector2(16, 16), Vector2(TILE_SIZE - 32, TILE_SIZE - 32))
	draw_rect(prect, Color(0.2, 0.9, 0.2), true)
	draw_rect(prect, Color.BLACK, false, 2)
	
	# Facing marker (a small triangle inside the player square)
	var center := prect.position + prect.size * 0.5
	var tip: Vector2
	var left: Vector2
	var right: Vector2
	var d := 14.0 # arrow size

	match facing:
		Facing.UP:
			tip = center + Vector2(0, -d)
			left = center + Vector2(-d * 0.7, d * 0.6)
			right = center + Vector2(d * 0.7, d * 0.6)
		Facing.DOWN:
			tip = center + Vector2(0, d)
			left = center + Vector2(-d * 0.7, -d * 0.6)
			right = center + Vector2(d * 0.7, -d * 0.6)
		Facing.LEFT:
			tip = center + Vector2(-d, 0)
			left = center + Vector2(d * 0.6, -d * 0.7)
			right = center + Vector2(d * 0.6, d * 0.7)
		Facing.RIGHT:
			tip = center + Vector2(d, 0)
			left = center + Vector2(-d * 0.6, -d * 0.7)
			right = center + Vector2(-d * 0.6, d * 0.7)

	# Draw question marks on the interactive tiles
	for cell in tiles.keys():
		var t: Tile = tiles[cell]
		if t.marker == "":
			continue

		var pos := GRID_ORIGIN + Vector2(cell) * TILE_SIZE
		var text := t.marker
		var text_size := question_font.get_string_size(text,HORIZONTAL_ALIGNMENT_CENTER,-1,question_font_size)
		var cell_center := pos + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)
		var draw_pos := cell_center - text_size / 2
		
		draw_string(question_font,draw_pos,text,HORIZONTAL_ALIGNMENT_CENTER,-1,question_font_size,Color(1,1,0))
			
	draw_colored_polygon([tip, left, right], Color(0, 0, 0))
