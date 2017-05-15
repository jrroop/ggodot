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

const GOBLIN_SPEED = 1
const MAGE_SPEED = 4
const GRID = 16

func mage_dir(var x, var y):
	moving = true
	direction = Vector2(x, y)
	mage_start_pos = get_node("mage").get_pos()
	
func make_kage():
	kageCount += 1
	var kage_inst = kage.instance()
	var kage_name = "kage"+str(kageCount)
	kage_inst.set_name(kage_name)
	add_child(kage_inst)
	get_node(kage_name).raise()
	var kage_pos = get_node("mage").get_pos()
	get_node(kage_name).set_pos(Vector2(kage_pos.x,kage_pos.y - 50))
	
func _ready():
	screen_size = get_viewport_rect().size
	mage_size = get_node("mage").get_texture().get_size()
	goblin_size = get_node("goblin").get_texture().get_size()
	set_process(true)

func _process(delta):
#	var mage_rect = Rect2( get_node("mage").get_pos() - mage_size*0.5, mage_size )
#	var goblin_rect = Rect2( get_node("goblin").get_pos() - goblin_size*0.5, mage_size )
	var mage_speed = MAGE_SPEED
	var goblin_speed = GOBLIN_SPEED
	var mage_pos = get_node("mage").get_pos()
	var goblin_pos = get_node("goblin").get_pos()

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
		make_kage()
		get_node("mage").set_pos(mage_pos + direction * MAGE_SPEED)
		if ( mage_pos == mage_start_pos + Vector2( GRID * direction.x, GRID * direction.y) ):
			moving = false	
	
	#Goblin Movement
	if(goblin_pos.y > 0):
		if(goblin_pos.y > mage_pos.y):
			goblin_pos.y -= goblin_speed + (delta * 10)
	if(goblin_pos.y < screen_size.y):
		if (goblin_pos.y <= mage_pos.y):
			goblin_pos.y += goblin_speed + (delta * 10)
#	if(goblin_pos.x > 0):
#		if(goblin_pos.x > mage_pos.x):
#			goblin_pos.x -= GOBLIN_SPEED * delta
#		else:
#	if(goblin_pos.x > screen_size.x):
#		if(goblin_pos.x <= mage_pos.x):
#			goblin_pos.x += GOBLIN_SPEED * delta
##			goblin_pos.x -= GOBLIN_SPEED * delta
	get_node("goblin").set_pos(goblin_pos)

