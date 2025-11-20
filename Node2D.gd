extends Node2D

var screen_size
var mage_size
var goblin_size
var exit_size
var direction = Vector2(0, 0)
var mage_start_pos
var input_string
var moving = false
var kage = preload("res://kage.tscn")
var kageCount = 0
var kageGroup
var mage_health = 3
var goblin_stopped = false

const GOBLIN_SPEED = 1
const MAGE_SPEED = 4
const GRID = 16

func mage_dir(x, y):
	moving = true
	direction = Vector2(x, y)
	mage_start_pos = get_node("mage").position

func clear_kage():
	for x in (get_tree().get_nodes_in_group("kage_grp")):
		x.queue_free()
	
func make_kage():
	kageCount += 1
	var kage_inst = kage.instantiate()
	var kage_name = "kage"+str(kageCount)
	kage_inst.name = kage_name
	add_child(kage_inst)
	kage_inst.add_to_group("kage_grp")
	
	var kage_pos = get_node("mage").position
	kage_inst.position = Vector2(kage_pos.x,kage_pos.y - 50)
	
func _ready():
	screen_size = get_viewport_rect().size
	mage_size = get_node("mage").texture.get_size()
	goblin_size = get_node("goblin").texture.get_size()
	exit_size = get_node("exit").texture.get_size()
	# set_process(true) # Not needed in Godot 4

func _process(delta):
	var mage_rect = Rect2( get_node("mage").position - mage_size*0.5, mage_size )
	var goblin_rect = Rect2( get_node("goblin").position - goblin_size*0.5, goblin_size )
	var exit_rect = Rect2( get_node("exit").position - exit_size*0.5, exit_size )
	
	var mage_speed = MAGE_SPEED
	var goblin_speed = GOBLIN_SPEED + (GRID * delta * 10)
	var mage_pos = get_node("mage").position
	var goblin_pos = get_node("goblin").position

	# Win Condition
	if mage_rect.intersects(exit_rect):
		print("YOU WIN")
		get_tree().quit()

	# Lose Condition
	if mage_rect.intersects(goblin_rect):
		mage_health -= 1
		print("Hit! Health: ", mage_health)
		if mage_health <= 0:
			print("GAME OVER")
			get_tree().quit()
		else:
			# Reset positions
			get_node("mage").position = Vector2(104.054, 173.877)
			get_node("goblin").position = Vector2(663.999, 309.498)
			mage_dir(0,0)
			moving = false
			return # Skip rest of frame

	# Kage Mechanic
	for k in get_tree().get_nodes_in_group("kage_grp"):
		var k_rect = Rect2(k.position - Vector2(10,10), Vector2(20,20)) # Approx size
		if k_rect.intersects(goblin_rect):
			goblin_stopped = true
			print("Goblin Stopped!")

	#Mage Movement
	if (!moving):
		if(mage_pos.y > 0 and Input.is_action_pressed("mage_move_up")):
			mage_dir(0,-1)
		if(mage_pos.y < screen_size.y and Input.is_action_pressed("mage_move_down")):
			mage_dir(0,1)
		if(mage_pos.x > 0 and Input.is_action_pressed("mage_move_right")):
			mage_dir(1,0)
		if(mage_pos.x < screen_size.x and Input.is_action_pressed("mage_move_left")):
			mage_dir(-1,0)
	else:
#		make_kage()
		get_node("mage").position = mage_pos + direction * MAGE_SPEED
		if ( mage_pos == mage_start_pos + Vector2( GRID * direction.x, GRID * direction.y) ):
			moving = false	
	if(Input.is_action_pressed("ui_select")):
#		clear_kage()
		make_kage()
		
	if(Input.is_action_pressed("ui_focus_next")):
		clear_kage()
	
	#Goblin Movement
	if not goblin_stopped:
		var direction_to_mage = (mage_pos - goblin_pos).normalized()
		var avoidance_vector = Vector2(0, 0)
		var avoidance_radius = 100.0 # Distance to start avoiding
		
		for k in get_tree().get_nodes_in_group("kage_grp"):
			var dist = goblin_pos.distance_to(k.position)
			if dist < avoidance_radius:
				# Vector away from Kage, weighted by distance (closer = stronger)
				avoidance_vector += (goblin_pos - k.position).normalized() * (avoidance_radius / max(dist, 1.0))
		
		# Combine vectors (Chase Mage + Avoid Kage)
		# Give avoidance higher priority/weight
		var final_direction = (direction_to_mage + avoidance_vector * 2.0).normalized()
		
		goblin_pos += final_direction * goblin_speed
		
		# Keep within screen bounds
		goblin_pos.x = clamp(goblin_pos.x, 0, screen_size.x)
		goblin_pos.y = clamp(goblin_pos.y, 0, screen_size.y)
		
		get_node("goblin").position = goblin_pos
