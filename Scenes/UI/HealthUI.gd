extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var hearth_ui = $Heart

func set_hearts(value):
	print(value)
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
