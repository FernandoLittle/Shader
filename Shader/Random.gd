extends Sprite2D
@export var v1:PackedVector2Array
@export var v2:PackedVector2Array
@export var v: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	v = Vector2(0.0, 0.0)
	
	for x in range(0, 50):
		v.x=randf_range(0.0,1.0)
		v.y=randf_range(0.0,1.0)
		v1[x]=v
		pass
	
	
	material.set_shader_parameter("position1",v1)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

