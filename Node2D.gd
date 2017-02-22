extends Node2D

var screen_size
var mage_size
var goblin_size
var direction = Vector2(1.0, 0.0)

const GOBLIN_SPEED = 60
var goblin_speed = GOBLIN_SPEED

const MAGE_SPEED = 80


func _process(delta):
	var mage_rect = Rect2( get_node("mage").get_pos() - mage_size*0.5, mage_size )
	var goblin_rect = Rect2( get_node("goblin").get_pos() - goblin_size*0.5, mage_size )
	var mage_pos = get_node("mage").get_pos()
	var goblin_pos = get_node("goblin").get_pos()

#Mage Movement
	if (mage_pos.y > 0 and Input.is_action_pressed("mage_move_up")):
		mage_pos.y += -MAGE_SPEED * delta
	if (mage_pos.y < screen_size.y and Input.is_action_pressed("mage_move_down")):
		mage_pos.y += MAGE_SPEED * delta
	if (mage_pos.x > 0 and Input.is_action_pressed("mage_move_right")):
		mage_pos.x += -MAGE_SPEED * delta
	if (mage_pos.x < screen_size.x and Input.is_action_pressed("mage_move_left")):
		mage_pos.x += MAGE_SPEED * delta

#Goblin Movement
	if (goblin_pos.y > mage_pos.y):
		goblin_pos.y += GOBLIN_SPEED * delta
	if (goblin_pos.y <= mage_pos.y):
		goblin_pos.y -= GOBLIN_SPEED * delta
	if (goblin_pos.x > mage_pos.x):
		goblin_pos.x += GOBLIN_SPEED * delta
	if (goblin_pos.x <= mage_pos.x):
		goblin_pos.x -= GOBLIN_SPEED * delta

func _ready():
	screen_size = get_viewport_rect().size
	mage_size = get_node("mage").get_texture().get_size()
	goblin_size = get_node("goblin").get_texture().get_size()
	set_process(true)