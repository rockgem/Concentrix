extends Node2D


enum TYPE{
	POINT,
	STATION
}

var type = TYPE.POINT
var sound_hz = 100.0
var sound_name = ''
var default_size = 0.32

var is_dragging = false





func _ready():
	if sound_name != '':
		$PredefinedSound.stream = load("res://sounds/sfx/%s.wav" % sound_name)


func _physics_process(delta):
	if is_dragging:
		look_at(get_global_mouse_position())
	
	if ManagerGame.world_ref:
		if type == TYPE.STATION:
			if $Inner/Area2D.has_overlapping_areas() and ManagerGame.world_ref.sustain_sounds and $PredefinedSound.playing == false and $AudioStreamPlayer.playing == false:
				print('play again')
				_on_area_2d_area_entered(null)


func _unhandled_input(event):
	if is_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false


func check_touching():
	if type == TYPE.POINT:
		for a in $Inner/Area2D.get_overlapping_areas():
			a.get_parent().get_parent()._on_area_2d_area_entered(null)


func _on_area_2d_area_entered(area):
	if type == TYPE.STATION:
		if sound_name != '':
			$PredefinedSound.play()
		else:
			var playback # Will hold the AudioStreamGeneratorPlayback.
			var sample_hz = $AudioStreamPlayer.stream.mix_rate
			
			$AudioStreamPlayer.play()
			playback = $AudioStreamPlayer.get_stream_playback()
			
			var phase = 0.0
			var increment = sound_hz / sample_hz
			var frames_available = playback.get_frames_available()
			
			for i in range(frames_available / 4):
				playback.push_frame(Vector2.ONE * sin(phase * TAU))
				phase = fmod(phase + increment, 1.0)


func _on_area_2d_area_exited(area):
	$PredefinedSound.stop()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if type != TYPE.POINT:
		return
	
	if is_dragging == false and event is InputEventMouse and event.button_mask == MOUSE_BUTTON_MASK_LEFT and event.is_pressed():
		is_dragging = true
