extends Sprite2D
var Mouse= Vector2(0.0,0.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Mouse= get_viewport().get_mouse_position()
	Mouse.x/= get_viewport_rect().size.x
	Mouse.y/= get_viewport_rect().size.y
	material.set_shader_parameter("MousePosition",Mouse)
	pass
