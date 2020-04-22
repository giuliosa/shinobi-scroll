extends KinematicBody2D

var walk_speed = 150

var velocity = Vector2(0, 0)

enum {UP, DOWN, LEFT, RIGHT}

var facing = DOWN

var switch_delta = Vector2(0,0)

func _physics_process(delta):
	if(switch_delta == Vector2(0,0)):
		var  walk_left = Input.is_action_pressed('left')
		var walk_right = Input.is_action_pressed('right')
		var walk_up = Input.is_action_pressed('up')
		var walk_down = Input.is_action_pressed('down')
		
		velocity = Vector2()
		if walk_left and position.x > -170:
			velocity.x = -walk_speed
			facing = LEFT
		elif walk_right and position.x < 389:
			velocity.x = walk_speed
			facing = RIGHT
		elif walk_up and position.y > -100:
			velocity.y = -walk_speed
			facing = UP
		elif walk_down and position.y < 466:
			velocity.y = walk_speed
			facing = DOWN	
	else:
		velocity = switch_delta * walk_speed
		
	velocity = move_and_slide(velocity)
	
	set_anim()
	
	
func set_anim():
	if facing == RIGHT:
		$AnimeMove.current_animation = "right_walk" if  velocity.x != 0 else "right_stand"
	elif facing == LEFT:
		$AnimeMove.current_animation = "left_walk" if  velocity.x != 0 else "left_stand"
	elif facing == UP:
		$AnimeMove.current_animation = "up_walk" if  velocity.y != 0 else "up_stand"
	elif facing == DOWN:
		$AnimeMove.current_animation = "down_walk" if  velocity.y != 0 else "down_stand"


func anim_switch(from, to):
	switch_delta = to.index - from.index
	var global  = global_position
	from.remove_child(self)
	to.add_child(self)
	global_position = global
	
	$SwitchTimer.start()

func _on_SwitchTimer_timeout():
	switch_delta = Vector2(0,0)
	get_parent().enter_chunk()