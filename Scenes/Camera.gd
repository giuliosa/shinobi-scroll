extends Camera2D

func anim_switch(delta):
	limit_left += delta.x * 576
	limit_right = limit_left + 576
	limit_top += delta.y *576
	limit_bottom = limit_top + 576