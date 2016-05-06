--require "/lua/background"

player = {}

function player.load()
	-- Posición del cortacesped
	player.corta_x, player.corta_y = 1, 1

	-- Pocisión inical del cortacesped
	bg.jardin[player.corta_x][player.corta_y] = 3

	-- Variable que indica que color pintar
	bg.click_color = 1

	-- Movimiento
	bg.move = true
	bg.vel, bg.vel_factor = 200, 15
	bg.time = 0

	-- Visitado
    visitado = {}
    for i = 1, 300 do
        visitado[i] = {}
        for j = 1, 300 do
            visitado[i][j] = 0
        end
    end

    visitado[1][1] = 1

    donde = {'d','s','a','w'}
    donde_x = {1,0,-1,0}
    donde_y = {0,1,0,-1}

    pila = {}
    pos = 0
end

function move(donde)
	local x_, y_ = 0, 0

	if donde == "d" and player.corta_x < bg.celda_x then x_, y_ = 1, 0 end -- derecha
	if donde == "a" and player.corta_x > 1 then x_, y_ = -1, 0 end -- izquierda
	if donde == "w" and player.corta_y > 1 then x_, y_ = 0, -1 end -- arriba
	if donde == "s" and player.corta_y < bg.celda_y then x_, y_ = 0, 1 end -- abajo

	-- Comprobamos contenido de la casilla a desplazar
	if bg.jardin[player.corta_x + x_][player.corta_y + y_] ~= 2 then
		bg.jardin[player.corta_x][player.corta_y] = 0
		player.corta_x, player.corta_y = player.corta_x + x_, player.corta_y + y_
		bg.jardin[player.corta_x][player.corta_y] = 3
	end
end

function player.movekey(key)
	-- Movimiento manual del cortacesped
	if key == 'right' then donde = "d" end
	if key == 'left' then donde = "a" end
	if key == 'up' then donde = "w" end
	if key == 'down' then donde = "s" end

	move(donde)
end



function player.automove(dt)
	if bg.move == true then
		local x_, y_ = player.corta_x, player.corta_y

		tmp = 1

		while player.corta_x == x_ and player.corta_y == y_ do
				if player.corta_x+donde_x[tmp] > 0 and player.corta_y+donde_y[tmp] > 0 then
					if visitado[player.corta_x+donde_x[tmp]][player.corta_y+donde_y[tmp]] == 0 then
						move(donde[tmp])
						if player.corta_x ~= 1 and player.corta_y ~= 1 then
							pasos = pasos + 1
						end
						if player.corta_x ~= x_ or player.corta_y ~= y_ then
							table.insert(pila, donde[tmp])
						end
					end
				end

				tmp = tmp + 1
				if tmp > 4 then break end
		end

		if player.corta_x == x_ and player.corta_y == y_ then
			if pila[#pila] == 'd' then move('a') end
			if pila[#pila] == 's' then move('w') end
			if pila[#pila] == 'a' then move('d') end
			if pila[#pila] == 'w' then move('s') end

			table.remove(pila)
			if player.corta_x ~= 1 and player.corta_y ~= 1 then
				pasos = pasos + 1
			end
		end

		-- Marca la última celda visitada
		visitado[player.corta_x][player.corta_y] = 1

		-- Asegura la repetición del bucle
		bg.move = false
	end

	bg.time = bg.time + bg.vel*dt
	if bg.time > bg.vel_factor then
		bg.move = true
		bg.time = 0
	end
end

function player.resize(key)
	-- Cambiar el número de celdas (limitado a 11 y 7 por la resolución)
	--if key == '1' and bg.celda_x + 1 < 11 then
	if key == '1' then
		bg.celda_x = bg.celda_x + 1

		-- Calcular tamaño de celda para ajustar la cuadrícula a la resolución
		while (bg.grid+bg.ancho_celda)*bg.celda_x > love.rwidth  do -- bg.bg.margen de 5 píxeles
			bg.ancho_celda = bg.ancho_celda - 0.01
		end
	end
	
	if key == '2' and bg.celda_x - 1 > 0 then
		bg.celda_x = bg.celda_x - 1

		-- Situa el cortacesped dentro de la cuadrícula (eje x)
		if player.corta_x > bg.celda_x then
			bg.jardin[player.corta_x][player.corta_y] = 0
			player.corta_x = bg.celda_x
			bg.jardin[player.corta_x][player.corta_y] = 3
		end

		if bg.celda_x > 12 then
			while (bg.grid+bg.ancho_celda)*bg.celda_x < love.rwidth  do -- bg.bg.margen de 5 píxeles
			bg.ancho_celda = bg.ancho_celda + 0.01
		end
		else bg.ancho_celda = bg.ancho_celdamax end
	end

	if key == 'q'  then
		bg.celda_y = bg.celda_y + 1

		while (bg.grid+bg.alto_celda)*bg.celda_y > love.rheight  do -- bg.bg.margen de 5 píxeles
			bg.alto_celda = bg.alto_celda - 0.01
		end
	end

	if key == 'w' and bg.celda_y - 1 > 0 then
		bg.celda_y = bg.celda_y - 1

		-- Situa el cortacesped dentro de la cuadrícula (eje y)
		if player.corta_y > bg.celda_y then
			bg.jardin[player.corta_x][player.corta_y] = 0
			player.corta_y = bg.celda_y
			bg.jardin[player.corta_x][player.corta_y] = 3
		end

		if bg.celda_y > 7 then
			while (bg.grid+bg.alto_celda)*bg.celda_y < love.rheight  do -- bg.bg.margen de 5 píxeles
			bg.alto_celda = bg.alto_celda + 0.01
		end
		else bg.alto_celda = bg.alto_celdamax end
	end
end

function player.mouse(key)
	-- Cambiar color a pintar con el botón derecho del ratón
	function love.mousepressed(x, y, button)
		if button == "r" then
			bg.click_color = bg.click_color + 1
			if bg.click_color > 2 then
				bg.click_color = 0
			end
		end
	end

	-- Posición inicial de la cuadrícula
	local x0_jardin = bg.grid+bg.ancho_celda - bg.ancho_celda + bg.margen_x
	local y0_jardin = bg.grid+bg.alto_celda - bg.alto_celda + bg.margen_y

	if love.mouse.isDown("l") then
		local x_, y_ = 0, 0
		local temp_x, temp_y = love.mouse_x - x0_jardin, love.mouse_y - y0_jardin

		while temp_x > bg.ancho_celda do
			temp_x = temp_x - bg.ancho_celda-bg.grid
			x_ = x_ + 1
		end

		while temp_y > bg.alto_celda do
			temp_y = temp_y - bg.alto_celda-bg.grid
			y_ = y_ + 1
		end

		if love.mouse_x > x0_jardin and love.mouse_x < love.rwidth - x0_jardin 
			and love.mouse_y > y0_jardin and love.mouse_y < love.rwidth - y0_jardin then
			bg.jardin[x_+1][y_+1] = bg.click_color
			if bg.click_color < 2 then
				visitado[x_+1][y_+1] = 0
			end

			bg.jardin[player.corta_x][player.corta_y] = 3
		end
	end
end


function UPDATE_PLAYER(dt, key)
	player.mouse(key)
	player.automove(dt)
end

function DRAW_PLAYER()
	--player.draw()
end
