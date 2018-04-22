extends Node

export (PackedScene) var loadingScreen

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_TryAgainButton_button_up():
    get_tree().change_scene_to(loadingScreen)