# Notes on Godot Script Coding and Godot Structure
* in a Godot (GD) project, we should be keeping our file structure organized:
  * the scenes
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



