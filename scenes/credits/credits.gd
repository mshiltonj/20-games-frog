@tool
extends Control

@onready var credits_text_label : Label = $CenterContainer/VBoxContainer/ScrollContainer/CreditsText

var sound_credits : String = """
Background Music:
	8-bit Air Fight -- moodmode
	https://pixabay.com/music/video-games-8-bit-air-fight-158813/
	
Jump SFX:
	gameboy pluck -- neezen
	https://pixabay.com/sound-effects/gameboy-pluck-41265/

Death SFX:
	Explosion 9 -- u_b32baquv5u
	https://pixabay.com/sound-effects/explosion-9-340460/
	
Home SFX:
	8-Bit Game 1 -- floraphonic
	https://pixabay.com/sound-effects/8-bit-game-1-186975/
	
Complete Level:
	LevelUp -- Kenneth_Cooney
	https://freesound.org/people/Kenneth_Cooney/sounds/609335/
	
TickTock: 
	Ticking Stopwatch (dry) -- DavidJGurney
	https://pixabay.com/sound-effects/ticking-stopwatch-dry-103837/
	
Game Over:
	https://sfbgames.itch.io/chiptone
"""

var font_credits : String = """
Title:
	Best Time - Khurasan
	https://www.dafont.com/bestime.font

Game Text:
	Press Start K - codeman38
	https://www.1001fonts.com/press-start-font.html
	
How to Play:
	Betsy Flanagan Regular - 
	https://www.1001fonts.com/betsy-flanagan-font.html

"""
func _ready() -> void:
	credits_text_label.text = sound_credits + "\n" + font_credits

func _on_button_pressed() -> void:
	SceneManager.load_scene("Main", self) # Replace with function body.
