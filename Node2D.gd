extends Node2D

const sprite_dimensions = Vector2(64,64)
const oversize_sprite_dimensions = Vector2(192,192)

export(Texture) var spritesheet
export(bool) var has_big_weapon = false
export(int) var cast_frames = 7
export(int) var thrust_frames = 8
export(int) var walk_frames = 9
export(int) var slash_frames = 6
export(int) var shoot_frames = 13
export(int) var hurt_frames = 6
export(int) var big_attack_frames = 0

var S
var F

const animation = {
	CAST_UP = 0,
	CAST_LEFT = 1,
	CAST_DOWN = 2,
	CAST_RIGHT = 3,
	THRUST_UP = 4,
	THRUST_LEFT = 5,
	THRUST_DOWN = 6,
	THRUST_RIGHT = 7,
	WALK_UP = 8,
	WALK_LEFT = 9,
	WALK_DOWN = 10,
	WALK_RIGHT = 11,
	SLASH_UP = 12,
	SLASH_LEFT = 13,
	SLASH_DOWN = 14,
	SLASH_RIGHT = 15,
	SHOOT_UP = 16,
	SHOOT_LEFT = 17,
	SHOOT_DOWN = 18,
	SHOOT_RIGHT = 19,
	HURT_DOWN = 20
}

# Called when the node enters the scene tree for the first time.
func _ready():
	new_sprite()
	$AnimatedSprite.frames = F
	
func new_sprite():
	# Instance new AnimatedSprite and SpriteFrames objects
	S = AnimatedSprite.new()
	F = SpriteFrames.new()
	F.remove_animation("default")
	
	# Process each of our frame types
	add_animation("cast")
	add_animation("thrust")
	add_animation("walk")
	add_animation("slash")
	add_animation("shoot")
	add_animation("hurt")
	
	# Set the AnimatedSprite's frames object
	S.frames = F
	# Write out the file
	ResourceSaver.save("res://output/Test_SpriteFrames.tres", F)

func add_animation(type: String):
	match type:
		"cast":
			make_frames("cast_up", animation.CAST_UP)
			make_frames("cast_left", animation.CAST_LEFT)
			make_frames("cast_down", animation.CAST_DOWN)
			make_frames("cast_right", animation.CAST_RIGHT)
		"thrust":
			make_frames("thrust_up", animation.THRUST_UP)
			make_frames("thrust_left", animation.THRUST_LEFT)
			make_frames("thrust_down", animation.THRUST_DOWN)
			make_frames("thrust_right", animation.THRUST_RIGHT)
		"walk":
			make_frames("walk_up", animation.WALK_UP)
			make_frames("walk_left", animation.WALK_LEFT)
			make_frames("walk_down", animation.WALK_DOWN)
			make_frames("walk_right", animation.WALK_RIGHT)
		"slash":
			make_frames("slash_up", animation.SLASH_UP)
			make_frames("slash_left", animation.SLASH_LEFT)
			make_frames("slash_down", animation.SLASH_DOWN)
			make_frames("slash_right", animation.SLASH_RIGHT)
		"shoot":
			make_frames("shoot_up", animation.SHOOT_UP)
			make_frames("shoot_left", animation.SHOOT_LEFT)
			make_frames("shoot_down", animation.SHOOT_DOWN)
			make_frames("shoot_right", animation.SHOOT_RIGHT)
		"hurt":
			make_frames("hurt_down", animation.HURT_DOWN)

func make_frames(name, row):
	print(spritesheet)
	F.add_animation(name)
	for col in range(0,cast_frames-1):
		var A = AtlasTexture.new()
		A.atlas = spritesheet
		A.region = Rect2(64*col,64*row,64,64)
		F.add_frame(name, A)
	print("Finished processing " + str(name))
	print("Frame count: " + str(F.get_frame_count(name)))
