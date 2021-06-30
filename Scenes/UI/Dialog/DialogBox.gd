extends Control

onready var richText = $RichTextLabel
onready var tween = $Tween
onready var arrow = $arrow
onready var faceset = $faceset

export (String, FILE, "*.json") var dialog_file_path : String

var dialog_index = 0
var finished = false

func _ready():
	load_dialog()
	
func _process(delta):
	arrow.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()
	
func load_dialog():
	var dialog : Dictionary = parse_dialog_json(dialog_file_path)
	
	if dialog_index < dialog.size():
		finished = false
		
		var line = dialog[String(dialog_index)]
		var imagePath = "res://assets/characters/faceset/"+line["name"]+".png"
		
		faceset.texture = load(String(imagePath))
		
		richText.bbcode_text = line["text"]
		richText.percent_visible = 0
		tween.interpolate_property(
			richText, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
	else:
		queue_free()
	dialog_index += 1


func _on_Tween_tween_all_completed():
	finished = true
	
func parse_dialog_json(file_path) -> Dictionary:
	"""
	Pases a JSON file and returns it as a dictionary
	"""
	
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	var dialog = parse_json(file.get_as_text())
	assert(dialog.size() > 0)
	return dialog

