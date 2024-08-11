extends Node3D
@export var barrinha: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Damage()
	pass
func Damage():
	Life.Vida-=Life.Pain;
	barrinha.value=Life.Vida/100
	pass
