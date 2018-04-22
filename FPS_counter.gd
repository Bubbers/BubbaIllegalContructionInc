extends CanvasLayer

export (bool) var display = false

var label

func _ready():
    label = $VisibilityEnabler2D/Label
    if display:
        $VisibilityEnabler2D.show()
    else:
        $VisibilityEnabler2D.hide()

func _process(delta):
    label.set_text(str(Engine.get_frames_per_second()))
