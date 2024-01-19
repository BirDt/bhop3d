@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BHop3D", "CharacterBody3D", preload("src/bhop3d.gd"), preload("src/icon.png"))

func _exit_tree():
	remove_custom_type("BHop3D")
