extends Node3D
@export var anime1: AnimationPlayer
@export var anime2: AnimationPlayer
@export var anime3: AnimationPlayer



@export var Coisa1: Node3D
@export var Coisa2: Node3D
@export var Coisa3: Node3D
@export var Coisa4: Node3D

@export var Kame1: Node3D
@export var Kame2: Node3D
@export var Kame3: Node3D
@export var Kame4: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	anime1.play("Kamehameha")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func ShowCoisas():
	Coisa1.show()
	#Coisa2.show()
	Coisa3.show()
	Coisa4.show()
	Kame1.show()
	anime2.play("Raios")
func DeactiveStuff():
	Coisa2.hide()
	Coisa4.hide()
	pass
	
func PlayKamehameha():
	Kame2.show()
	Kame3.show()
	Kame4.show()
	
	Coisa1.hide()
	Coisa2.hide()
	Coisa3.hide()
	anime3.play("Kamehameha")
