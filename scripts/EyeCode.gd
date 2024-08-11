extends MeshInstance3D
@export var myself: MeshInstance3D
@export var anime: AnimationPlayer
@export var a: int
@export var opentime: int
@export var opentexture: Texture
# Called when the node enters the scene tree for the first time.
func _ready():
	print("aaaa")

	opentime=randi_range(3,100);
	#$".".mesh.material.set_shader_parameter("scale",10.3)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(a<opentime):		
		a+=1
		if(a==opentime):
			$".".mesh.material.set_shader_parameter("texturinha",opentexture)
			
	pass
