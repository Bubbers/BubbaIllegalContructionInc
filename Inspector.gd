extends KinematicBody

signal detectedPlayer

export (float) var gravity = 10

var next_move_change = 0
var move_vector = Vector3(0.0, 0.0, 0.0)

const MOVE_SPEED = 5

const DEFAULT_TIME_BETWEEN_MOVES = 5000

func _ready():
    pass

func _process(delta):
    var current_time = OS.get_ticks_msec()

    if !is_on_floor():
        move_vector.y -= gravity*delta

    if current_time - next_move_change > 0:
        next_move_change = current_time + DEFAULT_TIME_BETWEEN_MOVES + randi() % 5000 - 2500

        move_vector = Vector3(0.0, 0.0, 0.0)

        if randi() % 2 == 0:
            move_vector += Vector3(1.0, 0.0, 0.0)
        if randi() % 2 == 0:
            move_vector += Vector3(-1.0, 0.0, 0.0)
        if randi() % 2 == 0:
            move_vector += Vector3(0.0, 0.0, 1.0)
        if randi() % 2 == 0:
            move_vector += Vector3(0.0, 0.0, -1.0)
    move_and_slide(move_vector * MOVE_SPEED, Vector3(0.0, 1.0, 0.0))

func _on_InspectionArea_body_entered(body):
    emit_signal("detectedPlayer")
