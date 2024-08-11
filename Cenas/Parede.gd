extends Node3D
@export var opentexture: Texture
@export var opentexture2: Texture
@export var opentexture3: Texture
@export var opentexture4: Texture
@export var opentexture5: Texture
@export var opentexture6: Texture
@export var opentexture7: Texture
@export var opentexture8: Texture
@export var opentexture9: Texture
@export var opentexture10: Texture
@export var opentexture11: Texture
@export var opentexture12: Texture
@export var opentexture13: Texture
@export var opentexture14: Texture
@export var opentexture15: Texture
@export var opentexture16: Texture
@export var ListTexture = []
@export var caos: int
@export var opentime: int
@export var a: int
@export var anime: AnimationPlayer
@export var Red: VisibleOnScreenNotifier3D


# Called when the node enters the scene tree for the first time.
func _ready():
	ListTexture=[opentexture,opentexture2,opentexture3,opentexture4,opentexture5,opentexture6,opentexture7,opentexture8,opentexture9,opentexture10,opentexture11,opentexture12,opentexture13,opentexture14,opentexture15,opentexture16]
	
	caos=randi_range(0,15)
	$Paredinha.mesh.material.albedo_texture = ListTexture[caos]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(a<opentime):		
		a+=1
		if(a==opentime):
			anime.play("ToRed")
			
	pass
func activePain():
	Red.show()
	pass


func _on_visible_on_screen_notifier_3d_screen_entered():
	Life.Pain+=1
	print(Life.Pain)
	pass # Replace with function body.


func _on_visible_on_screen_notifier_3d_screen_exited():
	Life.Pain-=1
	print(Life.Pain)
	pass # Replace with function body.
