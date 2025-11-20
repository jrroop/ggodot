extends Node2D

var screen_size
var mage_size
var goblin_size
var direction = Vector2(0, 0)
var mage_start_pos
var input_string
var moving = false
var kage = preload("res://kage.tscn")
var kageCount = 0
var kageGroup

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
	# set_process(true) # Not needed in Godot 4

func _process(delta):
#	var mage_rect = Rect2( get_node("mage").position - mage_size*0.5, mage_size )
#	var goblin_rect = Rect2( get_node("goblin").position - goblin_size*0.5, mage_size )
	var mage_speed = MAGE_SPEED
	var goblin_speed = GOBLIN_SPEED + (GRID * delta * 10)
	var mage_pos = get_node("mage").position
	var goblin_pos = get_node("goblin").position

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
	if(goblin_pos.y > 0):
		if(goblin_pos.y > mage_pos.y):
			goblin_pos.y -= goblin_speed
	if(goblin_pos.y < screen_size.y):
		if (goblin_pos.y <= mage_pos.y):
			goblin_pos.y += goblin_speed
#	if(goblin_pos.x > 0):
#		if(goblin_pos.x > mage_pos.x):
#			goblin_pos.x -= goblin_speed
#		else:
#			goblin_pos.x += goblin_speed
#	if(goblin_pos.x < screen_size.x):
#		if(goblin_pos.x <= mage_pos.x):
#			goblin_pos.x -= goblin_speed
#		else:
#			goblin_pos.x += goblin_speed
	get_node("goblin").position = goblin_pos

