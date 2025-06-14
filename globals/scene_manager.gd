extends Node

const SCENE_ROOT = "res://scenes/"

func load_scene(incoming_scene_name: String, outgoing_scene : Node = null) -> void:
	var incoming_scene_folder : String = Util.camel_to_snake(incoming_scene_name)	
	var scene_to_load : String = SCENE_ROOT + incoming_scene_folder + "/" + incoming_scene_name + ".tscn"	
	var incoming_packed_scene : PackedScene = load(scene_to_load)	
	get_tree().root.add_child(incoming_packed_scene.instantiate())
	
	if outgoing_scene:
		outgoing_scene.queue_free()
