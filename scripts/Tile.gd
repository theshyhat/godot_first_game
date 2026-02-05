class_name Tile
extends RefCounted

var cell: Vector2i
var solid: bool = false
var interactive: bool = false
var marker: String = ""

func _init(
	p_cell: Vector2i,
	p_solid: bool = false,
	p_interactive: bool = false,
	p_marker: String = ""
) -> void:
	cell = p_cell
	solid = p_solid
	interactive = p_interactive
	marker = p_marker
