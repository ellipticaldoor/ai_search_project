front = {}

function front.load()
    cursor = {
        bajo = love.graphics.newImage("/images/cursor_bajo.png"),
        alto = love.graphics.newImage("/images/cursor_alto.png"),
        obstaculo = love.graphics.newImage("/images/cursor_obstaculo.png"),
    }
end

function front.draw()
    -- Líneas correctoras de borde
    love.graphics.setColor(189, 195, 199)
    love.graphics.rectangle("fill", 0, 0, love.rwidth, 1)
    love.graphics.rectangle("fill", 0, love.rheight-1, love.rwidth, 1)
    love.graphics.rectangle("fill", 0, 0, 1, love.rheight)
    love.graphics.rectangle("fill", love.rwidth-1, 0, 1, love.rheight)

    -- Ratón
    love.graphics.setColor(255, 255, 255)
    if bg.click_color == 0 then love.graphics.draw(cursor.bajo, love.mouse.getX(), love.mouse.getY()) end
    if bg.click_color == 1 then love.graphics.draw(cursor.alto, love.mouse.getX(), love.mouse.getY()) end
    if bg.click_color == 2 then love.graphics.draw(cursor.obstaculo, love.mouse.getX(), love.mouse.getY()) end
end

function front.math(dt)

end

function UPDATE_FRONT(dt)
    front.math(dt)
end

function DRAW_FRONT()
    front.draw()
end
