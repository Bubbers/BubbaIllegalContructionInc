extends RigidBody

var mesh
var mesh_material

func _ready():
    mesh = $MeshInstance
    mesh_material = mesh.get_surface_material(0).duplicate()
    mesh_material.set_shader_param("is_emissive", false)
    mesh.set_surface_material(0, mesh_material)

func highlight(should_highlight):
    mesh_material.set_shader_param("is_emissive", should_highlight)
    
func retrieve_floor_mesh():
    return mesh


func _on_BrickFloor_body_entered(body):
    $SoundPlayer.play()
