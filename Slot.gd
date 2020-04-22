extends Panel

var id = null
var qty = 0
var uid = null
var Transaction = preload("res://Scenes/Transaction.tscn")

func store(trans):
	var all_done = true
	
	var i = 0
	while i != trans.size():
		var t = trans[i]
		if id != null and id != t.id or (uid != null and uid != t.uid):
			i += 1
			all_done = false
			continue
		
		id = t.id
		uid = t.uid
		
		if qty + t.qty > t.max_qty:
			t.qty -= (t.max_qty - qty)
			qty = t.max_qty
			all_done = false
			break
		else :
			qty += t.qty
			trans.remove(i)
	
	update_info()
	
	
func update_info():
	if id == null:
		$Image.texture = null
	else:
		$Image.texture = load("res://assets/items/item (" + str(id) + ").png")
		
	if qty > 1:
		$Number.text = str(qty)
		$Number.show() 
	else:
		$Number.hide()
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and pos_inside(event.position): 
		if Inventory.is_idle():
			# retirar
			if id == null: return
			
			var new_trans = Transaction.instance()
			if event.button_index == 1:
				new_trans.init(id, qty, uid)
				id = null
				qty = 0
				uid = null
			else:
				if qty == 1: return
				new_trans.init(id, qty/2, uid)
				qty -= qty/2
				
			Inventory.set_trans(new_trans)
			
			update_info()
			
			pass
		elif Inventory.is_trans():
			# colocar
			pass
		print(get_name())
	
func pos_inside(position):
	return get_global_rect().has_point(position)





