extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var hearth_ui = $Heart

func set_hearts(value):
	print("Corações")
	print(value/4)
	print("Resto")
	print(value%4)
	var hearts_now = []
	for i in range(value/4):
		hearts_now.append(4)
	if (value % 4) > 0:
		hearts_now.append(value % 4)
	print("Array")	
	print(hearts_now)
	for item in hearts_now.size():
		print("Item")
		
		print(item)		
		self.add_child(create_heart(item))
	hearts = clamp(value, 0, max_hearts)
	if hearts == 4:
		hearth_ui.frame = 0
	else: 
		hearth_ui.frame += 1
		
		
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

func create_heart(index):
	var forged_heart = Sprite.new()
	forged_heart.texture = load("res://assets/hud/heart.png")
	forged_heart.hframes = 5
	forged_heart.vframes = 1
	forged_heart.frame = 0
	forged_heart.set_position(Vector2(13.691 * (index + 1), 13.096)) 
	#To do 
	# Adicionar uma margem pros corações
	
	return forged_heart
