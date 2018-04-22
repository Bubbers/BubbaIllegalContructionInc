extends RigidBody

var mesh
var mesh_material
var should_play_sound = false
var timer

func _ready():
    mesh = $MeshInstance
    mesh_material = mesh.get_surface_material(0).duplicate()
    mesh_material.set_shader_param("is_emissive", false)
    mesh.set_surface_material(0, mesh_material)
    timer = Timer.new()
    timer.wait_time = 2
    timer.one_shot = true
    timer.connect("timeout",self,"_on_Timer_timeout") 

    add_child(timer)
    timer.start()

func highlight(should_highlight):
    mesh_material.set_shader_param("is_emissive", should_highlight)

func retrieve_floor_mesh():
    return mesh

func _on_BrickFloor_body_entered(body):
    if should_play_sound:
        $SoundPlayer.play()

func _on_Timer_timeout():
    should_play_sound = true
