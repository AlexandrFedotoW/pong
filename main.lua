function love.load()
    img_racket= love.graphics.newImage("images/Платформа3.png")
    racket1 = { x = 10, y = love.graphics.getHeight()/2, img = love.graphics.newImage("images/Платформа3.png"), width = img_racket:getWidth(), height = 150, dy = 6 }
    racket2 = { x = love.graphics.getWidth()-180, y = love.graphics.getHeight()/2, img = love.graphics.newImage("images/Платформа2.png"), width = img_racket:getWidth(), height = 150, dy = 6 }
    ball = { x = love.graphics.getWidth()/2 , y = love.graphics.getHeight()/2, img = love.graphics.newImage("images/Ракушка_мяч.png"), size = 10, dx = -6, dy = 1 }
    backgroundImage = love.graphics.newImage("images/Фон_игра.png")
    screenWidth =  love.graphics.getWidth()
    screenHeight =  love.graphics.getHeight()
    print(screenHeight)
    print(screenWidth)
    score1 = 0
    score2 = 0
end

function love.update(dt)
    

    if love.keyboard.isDown('w') and racket1.y > 0 then
        racket1.y = racket1.y - racket1.dy
    end
    if love.keyboard.isDown('s') and racket1.y < love.graphics.getHeight() - racket1.height then
        racket1.y = racket1.y + racket1.dy
    end

    if love.keyboard.isDown('up') and racket2.y > 0 then
        racket2.y = racket2.y - racket2.dy
    end
    if love.keyboard.isDown('down') and racket2.y < love.graphics.getHeight() - racket2.height then
        racket2.y = racket2.y + racket2.dy
    end

    ball.x = ball.x + ball.dx
    ball.y = ball.y + ball.dy

    if ball.y < 0 or ball.y > love.graphics.getHeight() - ball.size then
        ball.dy = -ball.dy
    end

    if ball.x < racket1.x + racket1.width and ball.y > racket1.y and ball.y < racket1.y + racket1.height then
        ball.dx = -ball.dx
    end
    if ball.x + ball.size > racket2.x and ball.y > racket2.y and ball.y < racket2.y + racket2.height then
        ball.dx = -ball.dx
    end

    if ball.x < 0 then
        score2 = score2 + 1
        ball.x = love.graphics.getWidth()/2 - 5
        ball.y = love.graphics.getHeight()/2 - 5
    end
    if ball.x + ball.size > love.graphics.getWidth() then
        score1 = score1 + 1
        ball.x = love.graphics.getWidth()/2 - 5
        ball.y = love.graphics.getHeight()/2 - 5
    end
end

function love.draw()
    local scaleImageX =  screenWidth  / backgroundImage:getWidth()
    local scaleImageY =  screenHeight /  backgroundImage:getHeight()
    love.graphics.draw(backgroundImage, 0, 0,0,scaleImageX,scaleImageY)
    -- love.graphics.draw(background)
    love.graphics.draw(racket1.img, racket1.x, racket1.y)
    love.graphics.draw(racket2.img, racket2.x, racket2.y)
    love.graphics.draw(ball.img, ball.x, ball.y)

    love.graphics.print(tostring(score1), love.graphics.getWidth()/2 - 50, 10)
    love.graphics.print(tostring(score2), love.graphics.getWidth()/2 + 30, 10)
end