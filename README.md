# LPC to Godot SpriteFrame Converter

This tool makes it easy to take LPC Sprites generated through 
https://github.com/sanderfrenken/Universal-LPC-Spritesheet-Character-Generator
and import them into your Godot games as SpriteFrames, ready to be loaded into
AnimatedSprite, AnimatedSprite3D, etc.

![](https://i.imgur.com/AiXlnnS.png)

## Usage
Copy the "addons" directory from this repository to your Godot project.

Click "Project", "Project Settings", and Enable the plugin. You should now have a new dock called "LPC_Converter". 

From here, you can load your LPC spritesheet downloaded from the website above and convert it to a SpriteFrames object ready to be used in your game. 

## Known Limitations
This converter does not yet support oversized weapons, which are a bit larger than normal frames. 
