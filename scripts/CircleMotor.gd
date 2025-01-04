extends Node3D
@export var BarA: float
@export var BarB: float

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#$MeshInstance3D.mesh.material.set_shader_parameter("BarreiraA",0.7);
	#$MeshInstance3D.mesh.material.set_shader_parameter("BarreiraB",0.7);
	var tween = get_tree().create_tween();
	tween.tween_property(self, "BarA", 1, 1).set_trans(Tween.TRANS_LINEAR);
	
	var tween2 = get_tree().create_tween();
	tween2.tween_property(self, "BarB", -2, 2).set_trans(Tween.TRANS_LINEAR);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MeshInstance3D.mesh.material.set_shader_parameter("BarreiraA",BarA);
	$MeshInstance3D.mesh.material.set_shader_parameter("BarreiraB",BarB);
	pass
