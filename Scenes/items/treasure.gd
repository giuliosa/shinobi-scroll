extends StaticBody2D

func _on_Hurtbox_area_entered(_area):
	open_treasure()

func open_treasure():
	#if Input.is_action_just_pressed("ui_action"):
	$Sprite.play()
