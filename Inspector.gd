extends KinematicBody

signal detectedPlayer

func _ready():
    pass

func _on_InspectionArea_body_entered(body):
    emit_signal("detectedPlayer")
