-- Добавлен новый флаг isBotEnabled
isBotEnabled = false
botSpeed = 4
botLerpFactor = 0.1

function love.load()
    img_racket = love.graphics.newImage("images/Платформа3.png")
    racket1 = { x = 10, y = love.graphics.getHeight() / 2, img = love.graphics.newImage("images/Платформа3.png"), width = img_racket:getWidth(), height = 150, dy = 6 }
    racket2 = { x = love.graphics.getWidth() - 180, y = love.graphics.getHeight() / 2, img = love.graphics.newImage("images/Платформа2.png"), width = img_racket:getWidth(), height = 150, dy = 6 }
    ball = { x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2, img = love.graphics.newImage("images/Ракушка_мяч.png"), size = 10, dx = -6, dy = 1 }
    backgroundImage = love.graphics.newImage("images/Фон_игра.png")
    menuBackground = love.graphics.newImage("images/фон_меню.png")
    button1Image = love.graphics.newImage("images/Кнопка_играть.png")
    button2Image = love.graphics.newImage("images/Кнопка_играть_с_ботом.png")
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    print(screenHeight)
    print(screenWidth)
    score1 = 0
    score2 = 0

    gameState = "menu"
    menuButton1 = { x = 400, y = 800, width = button1Image:getWidth(), height = button1Image:getHeight() }
    menuButton2 = { x = 1200, y = 800, width = button2Image:getWidth(), height = button2Image:getHeight() }
end

function love.update(dt)
    if gameState == "playing" then
        if love.keyboard.isDown('w') and racket1.y > 0 then
            racket1.y = racket1.y - racket1.dy
        end
        if love.keyboard.isDown('s') and racket1.y < love.graphics.getHeight() - racket1.height then
            racket1.y = racket1.y + racket1.dy
        end

        -- Управление второй ракеткой игроком или ботом
        if isBotEnabled then
            -- Простая логика бота с использованием линейной интерполяции
            local targetY = ball.y - racket2.height / 2
            racket2.y = racket2.y + (targetY - racket2.y) * botLerpFactor
        else
            if love.keyboard.isDown('up') and racket2.y > 0 then
                racket2.y = racket2.y - racket2.dy
            end
            if love.keyboard.isDown('down') and racket2.y < love.graphics.getHeight() - racket2.height then
                racket2.y = racket2.y + racket2.dy
            end
        end

        ball.x = ball.x + ball.dx
        ball.y = ball.y + ball.dy

        -- Обработка столкновения мяча с верхней и нижней границами
        if ball.y < 0 then
            ball.y = 0
            ball.dy = math.abs(ball.dy) -- Здесь используется math.abs, чтобы сделать направление положительным
        elseif ball.y + ball.size > love.graphics.getHeight() then
            ball.y = love.graphics.getHeight() - ball.size
            ball.dy = -math.abs(ball.dy) -- Здесь используется math.abs, чтобы сделать направление отрицательным
        end

        if ball.x < racket1.x + racket1.width and ball.x + ball.size > racket1.x and ball.y > racket1.y and ball.y + ball.size < racket1.y + racket1.height then
            ball.dx = -ball.dx
        end
        if ball.x + ball.size >= racket2.x and ball.x <= racket2.x + racket2.width and ball.y >= racket2.y and ball.y + ball.size <= racket2.y + racket2.height then
            ball.dx = -ball.dx
        end

        if ball.x < 0 then
            score2 = score2 + 1
            ball.x = love.graphics.getWidth() / 2 - 5
            ball.y = love.graphics.getHeight() / 2 - 5
        end
        if ball.x + ball.size > love.graphics.getWidth() then
            score1 = score1 + 1
            ball.x = love.graphics.getWidth() / 2 - 5
            ball.y = love.graphics.getHeight() / 2 - 5
        end

    elseif gameState == "menu" then
        local mouseX, mouseY = love.mouse.getPosition()
        if love.mouse.isDown(1) then
            if checkCollision(mouseX, mouseY, 1, 1, menuButton1) then
                gameState = "playing"
                isBotEnabled = false
                resetGame()
            elseif checkCollision(mouseX, mouseY, 1, 1, menuButton2) then
                gameState = "playing"
                isBotEnabled = true
                resetGame()
            end
        end
    end
end

function love.draw()
    if gameState == "playing" then
        local scaleImageX = screenWidth / backgroundImage:getWidth()
        local scaleImageY = screenHeight / backgroundImage:getHeight()
        love.graphics.draw(backgroundImage, 0, 0, 0, scaleImageX, scaleImageY)
        love.graphics.draw(racket1.img, racket1.x, racket1.y)
        love.graphics.draw(racket2.img, racket2.x, racket2.y)
        love.graphics.draw(ball.img, ball.x, ball.y)
        love.graphics.print(tostring(score1), love.graphics.getWidth() / 2 - 50, 10)
        love.graphics.print(tostring(score2), love.graphics.getWidth() / 2 + 30, 10)
    elseif gameState == "menu" then
        love.graphics.draw(menuBackground, 0, 0, 0, screenWidth / menuBackground:getWidth(), screenHeight / menuBackground:getHeight())
        love.graphics.draw(button1Image, menuButton1.x, menuButton1.y)
        love.graphics.draw(button2Image, menuButton2.x, menuButton2.y)
    end
end

function love.keypressed(key)
    if key == "escape" then
        if gameState == "playing" then
            gameState = "menu"
            resetGame()
        elseif gameState == "menu" then
            -- Добавьте логику, если нужно, когда находитесь в меню и нажимаете "Esc"
        end
    end
end

function checkCollision(x, y, width, height, object)
    return x > object.x and x < object.x + object.width and y > object.y and y < object.y + object.height
end

function resetGame()
    score1 = 0
    score2 = 0
    ball.x = love.graphics.getWidth() / 2 - 5
    ball.y = love.graphics.getHeight() / 2 - 5
end
