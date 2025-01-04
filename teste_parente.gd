extends Node3D
@export var parent:Node3D
@export var oldparent:Node3D
@export var child:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oldparent.remove_child(child)
	parent.add_child(child);
	print(0);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
