function love.conf(t)

	love.window.setMode(1280, 720)

	--Basic setup stuff
	t.title				= "Práctica IA"
	t.author			= "Agustín Miguel Dorta Sardiña, Javier García Iceta"
	
	--App identity and LOVE2D version
	t.identity			= "IA"
	t.console			= false
	t.release			= false -- Set to true for release mode
	t.version			= "0.8.0"
	
	--Screen dimensions and settings
	t.fullscreen		= true
	t.screen.width		= 1280
	t.screen.height		= t.screen.width / 16*9
	
	t.screen.vsync		= true
	t.screen.fsaa		= 0
	
	--Enable/Disable modules as needed, disabled slightly reduces startup
	t.modules.joystick	= false
	t.modules.audio		= true
	t.modules.keyboard	= true
	t.modules.event		= true
	t.modules.image		= true
	t.modules.graphics	= true
	t.modules.timer		= true
	t.modules.mouse		= true
	t.modules.sound		= true
	t.modules.physics	= true
end
