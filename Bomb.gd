extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Bomb_area_entered(area):
	$AnimatedSprite.play("Explode")


func _on_AnimatedSprite_animation_finished():
	if get_parent().life <= 0:
		get_parent().you_loose()
	if $AnimatedSprite.get_animation() == "Explode":
		queue_free()
	
