extends Node

export (PackedScene) var InspectorTemplate

func _ready():
    var newInspector = InspectorTemplate.instance()
    newInspector.connect("detectedPlayer", self, "detected")
    add_child(newInspector)
    
func detected():
    print("You got detected!")
