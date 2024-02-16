extends Node

var config = ConfigFile.new()
var err = config.load("user://options.cfg")

var mouseSens = config.get_value("options", "lookSensitivity")

func _ready():
	if err != OK:
		return
	elif err == OK:
		$VBoxContainer/Resolution/ResScaleLabel.text = str(config.get_value("options", "resolutionScale")*100) + "%"
		$VBoxContainer/Resolution/ResSlider.value = config.get_value("options", "resolutionScale")
		$VBoxContainer/FSR/FSRCheckBox.button_pressed = config.get_value("options", "fsr")
		$VBoxContainer/MouseSensitivity/SensSlider.value = config.get_value("options", "lookSensitivity")
		$VBoxContainer/MouseSensitivity/Label2.text = str(config.get_value("options", "lookSensitivity"))
		$VBoxContainer/VHSFilter/VHSFilterCheckbox.button_pressed = config.get_value("options", "vhs_filter")
		if config.get_value("options", "fullscreenMode") == 0:
			$VBoxContainer/Fullscreen/OptionButton.select(0)
		elif config.get_value("options", "fullscreenMode") == 1:
			$VBoxContainer/Fullscreen/OptionButton.select(1)
		elif config.get_value("options", "fullscreenMode") == 2:
			$VBoxContainer/Fullscreen/OptionButton.select(2)

func _process(_delta):
	pass

func _on_option_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		config.set_value("options", "fullscreenMode", 0)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		config.set_value("options", "fullscreenMode", 1)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		config.set_value("options", "fullscreenMode", 2)

func _on_fsr_check_box_toggled(button_pressed):
	if button_pressed == true:
		get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
		config.set_value("options", "fsr", true)
	elif button_pressed == false:
		get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		config.set_value("options", "fsr", false)

func _on_res_slider_value_changed(value):
	get_viewport().set_scaling_3d_scale(value)
	$VBoxContainer/Resolution/ResScaleLabel.text = str(value*100) + "%"
	config.set_value("options", "resolutionScale", $VBoxContainer/Resolution/ResSlider.value)

func _on_back_to_menu_pressed():
	if 	get_tree().get_current_scene().get_name() == "Menu":
		$/root/Menu/HBoxContainer.visible = !$/root/Menu/HBoxContainer.visible
		$/root/Menu/VBoxContainer.visible = !$/root/Menu/VBoxContainer.visible
	elif get_tree().get_current_scene().get_name() == "Player":
		$/root/PauseMenu/HBoxContainer.visible = !$/root/PauseMenu/HBoxContainer.visible
		$/root/PauseMenu/VBoxContainer.visible = !$/root/PauseMenu/VBoxContainer.visible
	$Label.visible = !$Label.visible
	$VBoxContainer.visible = !$VBoxContainer.visible

func _on_sens_slider_value_changed(value):
	config.set_value("options", "lookSensitivity", value)
	$VBoxContainer/MouseSensitivity/Label2.text = str(value)

func _on_backToMenu_pressed():
	$HBoxContainer.visible = !$HBoxContainer.visible
	$VBoxContainer.visible = !$VBoxContainer.visible
	$isThereALimit.visible = !$isThereALimit.visible
	$Options.visible = !$Options.visible
	config.save("user://options.cfg")

func _on_vhs_filter_checkbox_toggled(button_pressed):
	if get_tree().current_scene == $".":
		$Player/CanvasLayer3.visible = !$Player/CanvasLayer3.visible
		$Player/CanvasLayer.visible = !$Player/CanvasLayer.visible
		$Player/CanvasLayer4.visible = !$Player/CanvasLayer4.visible
		config.set_value("options", "vhs_filter", button_pressed)
	else:
		config.set_value("options", "vhs_filter", button_pressed)
	
