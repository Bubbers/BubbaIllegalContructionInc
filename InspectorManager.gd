extends Node

export (PackedScene) var SceneToSwitchToWhenDetected
export (PackedScene) var InspectorTemplate
export (int) var num_inspectors = 5
export (Vector2) var roads = Vector2(10, 10)
export (float) var street_length = 15

func _ready():
    for i in range(num_inspectors):
        var newInspector = InspectorTemplate.instance()
        newInspector.connect("detectedPlayer", self, "detected")
        var roadX = _rand_int(0, int(roads.x))
        var roadY = _rand_int(0, int(roads.y))
        newInspector.set_translation(Vector3((street_length) * roadX - 1, 0, (street_length) * roadY - 1))
        add_child(newInspector)
    
func _rand_int(minn, maxx):
    return randi() % (maxx - minn) + minn
    
func detected():
    print("You got detected!")
    global.lock_points()
    get_tree().change_scene_to(SceneToSwitchToWhenDetected)
