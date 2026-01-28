extends Node2D

const GRID_W := 4
const GRID_H := 4
const TILE_SIZE := 96

const GRID_ORIGIN := Vector2(64, 64)

var player_cell := Vector2i(0, 0)

func _ready() -> void:
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	var move := Vector2i.ZERO

	if event.is_action_pressed("move_up"):
		move = Vector2i(0, -1)
	elif event.is_action_pressed("move_down"):
		move = Vector2i(0, 1)
	elif event.is_action_pressed("move_left"):
		move = Vector2i(-1, 0)
	elif event.is_action_pressed("move_right"):
		move = Vector2i(1, 0)
	else:
		return

	var next := player_cell + move
	next.x = clamp(next.x, 0, GRID_W - 1)
	next.y = clamp(next.y, 0, GRID_H - 1)

	if next != player_cell:
		player_cell = next
		queue_redraw()

func _draw() -> void:
	for y in range(GRID_H):
		for x in range(GRID_W):
			var pos := GRID_ORIGIN + Vector2(x, y) * TILE_SIZE
			var rect := Rect2(pos, Vector2(TILE_SIZE, TILE_SIZE))

			draw_rect(rect, Color(0.15, 0.15, 0.15), true)
			draw_rect(rect, Color(0.4, 0.4, 0.4), false, 2)

	var ppos := GRID_ORIGIN + Vector2(player_cell) * TILE_SIZE
	var prect := Rect2(ppos + Vector2(16, 16), Vector2(TILE_SIZE - 32, TILE_SIZE - 32))

	draw_rect(prect, Color(0.2, 0.9, 0.2), true)
	draw_rect(prect, Color.BLACK, false, 2)
