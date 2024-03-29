extends KinematicBody2D

const PlayerHurtSound = preload("res://Scenes/Player/PlayerHurtSound.tscn")

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 400
const ROLL_SPEED = 150
#const FogEffect = preload("res://Scenes/Effects/FogEffect.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/AttackHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var weapon = $HitboxPivot/Weapon

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	#weapon.texture.

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state()
			
		ATTACK:
			attack_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK

func roll_state():
	#var fog = FogEffect.instance()
	#get_parent().add_child(fog)
	#fog.global_position = global_position
	# TODO: Teleport effect with the fog
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
	


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invicibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	


func _on_Hurtbox_invicibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invicibility_ended():
	blinkAnimationPlayer.play("Stop")
