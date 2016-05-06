bg = {}

function bg.load()
    -- Número de celdas
    bg.celda_x = 10
    bg.celda_y = 6
    
    -- Área de las celdas
    bg.ancho_celda, bg.alto_celda = 100, 100
    bg.ancho_celdamax, bg.alto_celdamax = 100, 100

    -- Tamaño del borde de la cuadrícla
    bg.grid = 1

    if bg.celda_x > 12 then
        while (bg.grid+bg.ancho_celda)*bg.celda_x > love.rwidth  do
            bg.ancho_celda = bg.ancho_celda - 0.01
        end
    end

    if bg.celda_y > 7 then
        while (bg.grid+bg.alto_celda)*bg.celda_y > love.rheight  do
            bg.alto_celda = bg.alto_celda - 0.01
        end
    end

    -- Celdas del jardin
    bg.jardin = {}
    for i = 1, 300 do
        bg.jardin[i] = {}
        for j = 1, 300 do
            bg.jardin[i][j] = math.random(0,2)
            if bg.jardin[i][j] == 2 then
                bg.jardin[i][j] = math.random(0,2)
            end
        end
    end
end

function bg.draw()
    -- Fondo
    love.graphics.setColor(189, 195, 199)
    love.graphics.rectangle("fill", 0, 0, love.rwidth, love.graphics.getHeight())

    -- Representación del ancho de las celdas
    for i = 1, bg.celda_x do
        for j = 1, bg.celda_y do

            --[[
                0 = cesped bajo
                1 = cesped alto
                2 = obstáculo
                3 = ocupado
            ]]--

            if bg.jardin[i][j] == 0 then love.graphics.setColor(52, 160, 219) end
            if bg.jardin[i][j] == 1 then love.graphics.setColor(0, 85, 130) end
            if bg.jardin[i][j] == 2 then love.graphics.setColor(230, 126, 34) end 
            if bg.jardin[i][j] == 3 then love.graphics.setColor(236, 240, 241) end

            love.graphics.rectangle("fill",
                                    (bg.grid+bg.ancho_celda)*i - bg.ancho_celda + bg.margen_x,
                                    (bg.grid+bg.alto_celda)*j - bg.alto_celda + bg.margen_y,
                                    bg.ancho_celda, bg.alto_celda
                                    ) 
        end
    end


end

function bg.math(dt)
    -- Margen para centrar la cuadrícula
    bg.margen_x = (love.rwidth - (bg.grid+bg.ancho_celda)*bg.celda_x)/2 - bg.grid/2
    bg.margen_y = (love.rheight - (bg.grid+bg.alto_celda)*bg.celda_y)/2 - bg.grid/2
end

function bg.random(key)
    pasos = 0
    
    if key == 'r' then
        for i = 1, 300 do
            bg.jardin[i] = {}
            for j = 1, 300 do
                bg.jardin[i][j] = math.random(0,2)
                if bg.jardin[i][j] == 2 then
                    bg.jardin[i][j] = math.random(0,2)
                end
            end
        end

        player.corta_x, player.corta_y = 1, 1

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

    bg.jardin[player.corta_x][player.corta_y] = 3
end

function UPDATE_BG(dt)
    bg.math(dt)
end

function DRAW_BG()
    bg.draw()
end
