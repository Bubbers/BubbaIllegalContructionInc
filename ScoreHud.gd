extends CanvasLayer

var label

func _ready():
    label = $Label

func _on_score_changed(score):
    label.text = "Score: " + str(score)
