extends Node

var loader
var wait_frames = 1
var time_max = 10
var current_scene

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child(root.get_child_count() -1)
    goto_scene("res://Main.tscn")

func goto_scene(path): # game requests to switch to this scene
    print("Entering Goto with %s" %path)
    loader = ResourceLoader.load_interactive(path)
    if loader == null: # check for errors
        show_error()
        return
        
    set_process(true)

func _process(time):
    if loader == null:
        # no need to process anymore
        set_process(false)
        return

    if wait_frames > 0: # wait for frames to let the "loading" animation to show up
        wait_frames -= 1
        return

    var t = OS.get_ticks_msec()
    while t < OS.get_ticks_msec() + time_max: # use "time_max" to control how much time we block this thread

        var err = loader.poll()

        if err == ERR_FILE_EOF: # load finished
            var resource = loader.get_resource()
            loader = null
            set_new_scene(resource)
            break
        elif err == OK:
            update_progress()
        else: # error during loading
            show_error()
            loader = null
            break
            
func update_progress():
    var progress = float(loader.get_stage()) / loader.get_stage_count()
    $ProgressBar.value = (progress)


func set_new_scene(scene_resource):    
    current_scene.queue_free() # get rid of the old scene
    current_scene = scene_resource.instance()
    get_node("/root").add_child(current_scene)