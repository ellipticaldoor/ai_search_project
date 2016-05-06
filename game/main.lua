require "/lua/background"
require "/lua/front"
require "/lua/player"

math.randomseed( os.time() )

function love.load()
	pasos = 0
	-- Cambiar resolución
	love.window.setMode(1280, 720)
	--love.window.setMode(1440, 900, {vsync = true, fullscreen = "true"})

	f = love.graphics.newFont( "fonts/Red_Alert_INET.ttf", 48 )
	love.graphics.setFont(f)

	-- Detectar resolución
	love.rwidth = love.graphics.getWidth()
	love.rheight = love.graphics.getHeight()

	--Loading classes
	love.mouse.setVisible(false)

	bg.load()
	player.load()
	front.load()
end

function love.update(dt)
	love.mouse_x, love.mouse_y = love.mouse.getPosition()

	UPDATE_BG(dt)
	UPDATE_PLAYER(dt)
	UPDATE_FRONT(dt)

	local fps=love.timer.getFPS
	love.window.setTitle("IA - "..fps().." FPS")
end

function love.draw()
	if scale ~= 1 then love.graphics.scale(scale) end

	DRAW_BG()
	DRAW_PLAYER()
	DRAW_FRONT()

	--[[love.graphics.setColor(44,62,80,70)
	love.graphics.rectangle("fill",0,0,1280,50)
	love.graphics.setColor(236,240,241)
	love.graphics.print("Pasos: "..pasos.."",10,0)]]--
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end

	player.movekey(key)
	player.resize(key)
	bg.random(key)
end
