extends KinematicBody

export (float) var gravity = 10
export (float) var jump_force = 5
export (float) var moving_speed = 5

const MOUSE_SENSITIVITY = 0.005

var velocity = Vector3()

var rotation_helper
var camera
var interact_ray
var previous_interact_object = null

var item_held_old_parent = null
var item_held = null

var cam_pitch = 0.0;
var cam_yaw = 0.0;
var cam_currentradius = 3.0;

func _ready():
    rotation_helper = $RotationHelper
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #This might not work in a browser
    camera = $RotationHelper/FPVCamera
    interact_ray = $RotationHelper/FPVCamera/InteractRay
    add_to_group("player", true)

func _process(delta):

    var direction = calculate_movement()

    handle_vertical_motion(delta)    
    
    handle_object_interaction()

    move_and_slide(velocity + direction, Vector3(0,1,0))

    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            
func calculate_movement():
    
    var direction = Vector3()
    var camera_transform = rotation_helper.global_transform

    if Input.is_action_pressed("forward"):
        direction -= camera_transform.basis.z.normalized()
    if Input.is_action_pressed("backward"):
        direction += camera_transform.basis.z.normalized()
    if Input.is_action_pressed("right"):
        direction += camera_transform.basis.x.normalized()
    if Input.is_action_pressed("left"):
        direction -= camera_transform.basis.x.normalized()
        
    return direction.normalized() * moving_speed

func handle_vertical_motion(delta):
    
    if !is_on_floor():
        velocity.y -= gravity*delta
    elif Input.is_action_just_pressed("jump"):
        velocity.y = jump_force
    else:
        velocity.y = 0
        
func handle_object_interaction():
    var is_colliding = interact_ray.is_colliding()
    var building_floor = interact_ray.get_collider()
    
    _highlight_selected_object(is_colliding, building_floor)
        
    if is_colliding and Input.is_action_just_pressed("interact") and item_held == null:
        var floor_parent = building_floor.get_parent()
        floor_parent.remove_child(building_floor)
        var building_mesh = building_floor.retrieve_floor_mesh()
        building_floor.remove_child(building_mesh)
        rotation_helper.add_child(building_mesh)
        building_mesh.set_scale(building_mesh.get_scale()*0.1)
        
        building_mesh.set_translation(Vector3(2, 1, -2))
        item_held = building_mesh
        item_held_old_parent = building_floor
        $AudioStreamPlayer2D.play()

    elif Input.is_action_just_pressed("interact") and item_held != null:
        item_held.get_parent().remove_child(item_held)
        item_held_old_parent.add_child(item_held)
        get_parent().add_child(item_held_old_parent)
        item_held.set_scale(item_held.get_scale() * 10)
        item_held.set_translation(Vector3(0, 0, 0))

        var placementOffset = Vector3(0.0, 0.0, -1.0).rotated(Vector3(0.0, 1.0, 0.0), cam_yaw) * 10

        item_held_old_parent.set_translation(get_translation() + placementOffset)
        item_held_old_parent.rotation = rotation_helper.rotation

        item_held = null
        item_held_old_parent = null


func _highlight_selected_object(is_colliding, building_floor):
    if is_colliding:
        if building_floor != previous_interact_object: 
            building_floor.highlight(true)
            
            if previous_interact_object != null:
                previous_interact_object.highlight(false)
            
            previous_interact_object = building_floor
    elif previous_interact_object != null:
        previous_interact_object.highlight(false)
        previous_interact_object = null

func _input(event):
    if event is InputEventMouseMotion:
        var relative = event.relative
        rotation_helper.rotate_y(-relative.x * MOUSE_SENSITIVITY)

        cam_yaw -= relative.x * MOUSE_SENSITIVITY
        cam_pitch += relative.y * MOUSE_SENSITIVITY
        cam_pitch = clamp(cam_pitch, - PI/8, PI / 2.1)

        var head_pos = Vector3(0, 1, 0) + get_global_transform().origin
        var cam_pos = head_pos
        cam_pos.x += cam_currentradius * sin(cam_yaw) * cos(cam_pitch)
        cam_pos.y += cam_currentradius * sin(cam_pitch)
        cam_pos.z += cam_currentradius * cos(cam_yaw) * cos(cam_pitch)

        camera.look_at_from_position(cam_pos, head_pos, Vector3(0, 1, 0))
        
        

