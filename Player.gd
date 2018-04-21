extends KinematicBody

export (float) var gravity = 10
export (float) var jump_force = 5
export (float) var moving_speed = 12

const MOUSE_SENSITIVTY = 0.005

var velocity = Vector3()

var rotation_helper
var camera

var cam_pitch = 0.0;
var cam_yaw = 0.0;
var cam_cpitch = 0.0;
var cam_cyaw = 0.0;
var cam_currentradius = 8.0;
var cam_radius = 2.0;

func _ready():
    rotation_helper = $RotationHelper
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #This might not work in a browser
    camera = $RotationHelper/FPVCamera

func _process(delta):

    var direction = Vector3()
    var camera_transform = camera.get_global_transform()

    if Input.is_action_pressed("forward"):
        direction -= camera_transform.basis.z.normalized()
    if Input.is_action_pressed("backward"):
        direction += camera_transform.basis.z.normalized()
    if Input.is_action_pressed("right"):
        direction += camera_transform.basis.x.normalized()
    if Input.is_action_pressed("left"):
        direction -= camera_transform.basis.x.normalized()
    direction = direction.normalized() * moving_speed

    if !is_on_floor():
        velocity.y -= gravity*delta
    #elif Input.is_action_just_pressed("jump"):
     #   velocity.y = jump_force
    else:
        velocity.y = 0

    move_and_slide(velocity + direction, Vector3(0,1,0))

    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
    if event is InputEventMouseMotion:
        var relative = event.relative
        rotation_helper.rotate_y(-relative.x * MOUSE_SENSITIVTY)

        cam_yaw -= relative.x * MOUSE_SENSITIVTY
        cam_pitch += relative.y * MOUSE_SENSITIVTY
        cam_pitch = clamp(cam_pitch, 0.0, PI / 2)

        var head_pos = Vector3(0, 3.6, 0) + get_global_transform().origin
        var cam_pos = head_pos
        cam_pos.x += cam_currentradius * sin(cam_yaw) * cos(cam_pitch)
        cam_pos.y += cam_currentradius * sin(cam_pitch)
        cam_pos.z += cam_currentradius * cos(cam_yaw) * cos(cam_pitch)

        camera.look_at_from_position(cam_pos, head_pos, Vector3(0, 1, 0))

