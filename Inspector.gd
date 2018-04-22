extends KinematicBody

signal detectedPlayer

export (float) var gravity = 10

var next_move_change = 0
var move_vector = Vector3(0.0, 0.0, 0.0)

var rotation_helper
var sight_ray_caster

const MOVE_SPEED = 5

const DEFAULT_TIME_BETWEEN_MOVES = 5000

var seen_player_object = null

func _ready():
    rotation_helper = $RotationHelper
    sight_ray_caster = $RotationHelper/SightRay

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
            
        move_vector = move_vector.normalized()

        if move_vector.length() != 0:
            var angle = Vector2(0, 1).angle_to(Vector2(move_vector.x, move_vector.z))
            rotation_helper.set_rotation(Vector3(PI / 2,-angle,0))

    move_and_slide(move_vector * MOVE_SPEED, Vector3(0.0, 1.0, 0.0))


    if sight_ray_caster.is_colliding():
        var seen_object = sight_ray_caster.get_collider()
        if seen_object.is_in_group("player"):
            emit_signal("detectedPlayer")

    point_raycaster_to_player()

func point_raycaster_to_player():
    if seen_player_object != null:
        var player_position = seen_player_object.rotation_helper.to_global(seen_player_object.rotation_helper.get_translation())
        sight_ray_caster.set_cast_to(rotation_helper.to_local(player_position) + Vector3(0.0, 0.0, -1.0))

func _on_InspectionArea_body_entered(body):
    if body.is_in_group("player"):
        seen_player_object = body


func _on_InspectionArea_body_exited(body):
    if body.is_in_group("player"):
        seen_player_object = null
        sight_ray_caster.set_cast_to(Vector3(10.0, 1.0, 0.0))