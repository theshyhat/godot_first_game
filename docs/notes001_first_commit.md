# Notes on Godot Script Coding and Godot Structure
* in a Godot (GD) project, we should be keeping our file structure organized:
  * the scenes, addons, assets, and scripts directories should all be setup immediately upon project creation
## Godot Components
### Scenes
* scenes are a saved node tree with a root node
* they could serve the role of:
  * levels
  * menus
  * game characters
  * buttons
  * dialog boxes
* they are the thing that contain and organize nodes
### Nodes
* nodes are game objects
* nodes are runtime objects with a specific engine class
* nodes exist in a hierarchical tree
* every GD project runs one giant tree of nodes
* they are specialized to do a specific task
* every node has one parent
* each node can have many children
* we can think of a node as an instance of a class (Object Oriented Programming)
* in GD, we would have separate nodes for:
  * movement
  * graphics
  * collision
  * sound
  * input
### Scripts
* class definitions that extend Node types
* attached to a node instance
* gives a node behavior
* if nodes are objects, then scripts are class logic for those objects
* scripts define a class
* they can override methods
* they define:
  * properties
  * methods
  * signals
* the GD engine calls scripts, we do not directly call them
* GD script (the language):
  * is dynamically typed, with optional static typing
  * is indentation-based, like Python
  * is either interpreted or JIT-compiled
  * integrated into the GD engine
  * uses the `extends` keyword as opposed to the Python keyword `class`
  * uses signals instead of callbacks
    * callbacks involve one object interacting with another object, the callback object has to know the listening object
    * signals are named events emitted by nodes, the listening object knows the emitting object
  *  do not allow arbitrary global execution
  *  refers to all functions as `methods`, even though they're created with the `func` keyword....
* scripts can exist without being attached to nodes, but they do nothing unless they are attached
* scripts define `behavior`, nodes define `existence`, scenes define `composition`
### Assets
* assets are files that live inside a project and can be loaded, referenced, or instantiated by the engine
* they can be:
  * images `.png` `.jpg` `.webp` etc..
    * used by `Sprite2D`, `TextureRect`, materials, etc
  * music / sound effects `.wav` `.ogg` `.mp3` etc..
    * used by `AudioStreamPlayer`
  * video `.ogv`
    * used by `VideoStreamPlayer`
  * scenes `.tscn` or `.scn`
    * they can be referenced, reloaded, and reused anywhere
    * can be prefabs, object factories, and modular building blocks
  * scripts `.gd` or `.cs`
    * live as files in the project
    * can be reused across nodes
    * can be referenced
    * scripts, however, are mostly attached to nodes and used indirectly
  * resources (data objects)
    * fonts
    * shaders
    * animations
    * materials
    * curves
  * data files
* assets are all reusable project resources
* assets are imported automatically
* get .import metadata files
* assets are referenced, not copied
* all assets are filed under the the `res://` project root

## The code for our first script files
### Main.gd
```
# a class that inherits from Node2D, the base class for 2D objects with a transform (position/rotation/scale)
extends Node2D

# Defines the grid configuration for the level
const GRID_W := 4 # := is integer inference
const GRID_H := 4
const TILE_SIZE := 96 # defines how large each tile is in pixels

# A Vector2 is a 2D float vector (x, and y)
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
```

