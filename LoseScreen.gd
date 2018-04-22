extends Node

export (PackedScene) var loadingScreen

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    $Score.set_text("Score: " + str(global.get_points()))
    $MaxScore.set_text("Max score: " + str(global.get_max_points()))

func _on_TryAgainButton_button_up():
    get_tree().change_scene_to(loadingScreen)