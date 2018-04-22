extends Area

signal points_changed

var points

func _ready():
    points = 0

func _on_Area_body_entered(body):
    points += 1
    emit_signal("points_changed", points)
    print("points are ", points)


func _on_Area_body_exited(body):
    points -= 1
    emit_signal("points_changed", points)
    print("points are ", points)
