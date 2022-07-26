# MIT License
# 
# Copyright (c) 2022 Lincoln Bryant
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

tool
extends VBoxContainer

const sprite_dimensions = Vector2(64,64)
const oversize_sprite_dimensions = Vector2(192,192)

var spritesheet_path: String
var output_file: String
var oversized_weapon = false
var framerate = 10
var cast_frames = 7
var thrust_frames = 8
var idle_frames = 1
var walk_frames = 8
var slash_frames = 6
var shoot_frames = 13
var hurt_frames = 6
var oversize_frames = 0

var S # AnimatedSprite
var F # SpriteFrames
var spritesheet

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

# Signal handlers
func _on_FilePath_pressed():
	var dialog = $FileDialog
	center_dialog(dialog)
	dialog.popup()


func _on_OutputDirPath_pressed():
	var dialog = $OutputDialog
	center_dialog(dialog)
	dialog.popup()


func _on_GenerateFrames_pressed():
	spritesheet_path = $SpritePath/Value.text
	output_file = $OutputPath/Value.text
	oversized_weapon = $OversizeWeapon/Value.pressed
	cast_frames = $CastFrames/Value.value
	thrust_frames = $ThrustFrames/Value.value
	walk_frames = $WalkFrames/Value.value
	idle_frames = $IdleFrames/Value.value
	slash_frames = $SlashFrames/Value.value
	shoot_frames = $ShootFrames/Value.value
	oversize_frames = $OversizeFrames/Value.value
	framerate = $Framerate/Value.value
	new_sprite()


func _on_FileDialog_file_selected(path):
	$SpritePath/Value.text = path


func _on_OutputDialog_file_selected(path):
	$OutputPath/Value.text = path


# Internal functions
func show_dialog(title: String, msg: String):
	var dialog = $WarnDialog
	center_dialog(dialog)
	dialog.window_title = title
	dialog.dialog_text = msg
	dialog.popup()


func center_dialog(dialog: Node):
	var posX
	var posY
	if get_viewport().size.x <= dialog.get_rect().size.x:
		posX = 0
	else:
		posX = (get_viewport().size.x - dialog.get_rect().size.x) / 2
	if get_viewport().size.y <= dialog.get_rect().size.y:
		posY = 0
	else:
		posY = (get_viewport().size.y - dialog.get_rect().size.y) / 2
	dialog.set_position(Vector2(posX, posY))

func new_sprite():
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(spritesheet_path)
	texture.create_from_image(image)
	texture.flags = 0 # pixel
	spritesheet = texture
	# Instance new AnimatedSprite and SpriteFrames objects
	S = AnimatedSprite.new()
	F = SpriteFrames.new()
	F.remove_animation("default")

	# Process each of our frame types
	add_animation("cast")
	add_animation("thrust")
	add_animation("idle")
	add_animation("walk")
	add_animation("slash")
	add_animation("shoot")
	add_animation("hurt")
	
	# Set the AnimatedSprite's frames object
	S.frames = F
	# Write out the file
	if output_file:
		ResourceSaver.save(output_file, F)
	else:
		print("No output file selected! Not saving to disk.")

func add_animation(type: String):
	match type:
		"cast":
			make_frames("cast_up", cast_frames, animation.CAST_UP)
			make_frames("cast_left", cast_frames, animation.CAST_LEFT)
			make_frames("cast_down", cast_frames, animation.CAST_DOWN)
			make_frames("cast_right", cast_frames, animation.CAST_RIGHT)
		"thrust":
			make_frames("thrust_up", thrust_frames, animation.THRUST_UP)
			make_frames("thrust_left", thrust_frames, animation.THRUST_LEFT)
			make_frames("thrust_down", thrust_frames, animation.THRUST_DOWN)
			make_frames("thrust_right", thrust_frames, animation.THRUST_RIGHT)
		"idle":
			make_frames("idle_up", idle_frames, animation.WALK_UP)
			make_frames("idle_left", idle_frames, animation.WALK_LEFT)
			make_frames("idle_down", idle_frames, animation.WALK_DOWN)
			make_frames("idle_right", idle_frames, animation.WALK_RIGHT)
		"walk":
			make_frames("walk_up", walk_frames, animation.WALK_UP)
			make_frames("walk_left", walk_frames, animation.WALK_LEFT)
			make_frames("walk_down", walk_frames, animation.WALK_DOWN)
			make_frames("walk_right", walk_frames, animation.WALK_RIGHT)
		"slash":
			make_frames("slash_up", slash_frames, animation.SLASH_UP)
			make_frames("slash_left", slash_frames, animation.SLASH_LEFT)
			make_frames("slash_down", slash_frames, animation.SLASH_DOWN)
			make_frames("slash_right", slash_frames, animation.SLASH_RIGHT)
		"shoot":
			make_frames("shoot_up", shoot_frames, animation.SHOOT_UP)
			make_frames("shoot_left", shoot_frames, animation.SHOOT_LEFT)
			make_frames("shoot_down", shoot_frames, animation.SHOOT_DOWN)
			make_frames("shoot_right", shoot_frames, animation.SHOOT_RIGHT)
		"hurt":
			make_frames("hurt_down", hurt_frames, animation.HURT_DOWN)

func make_frames(name, frames, row):
	F.add_animation(name)
	F.set_animation_speed(name, framerate)
	for col in range(frames):
		if "walk" in name && col == 0:
				continue
		print("Making frames for " + str(name))
		var A = AtlasTexture.new()
		A.atlas = spritesheet
		A.region = Rect2(64*col,64*row,64,64)
		F.add_frame(name, A)
