function love.load()
    Object = require "classic"
    require "character"
    require "enemy"
    Music = love.audio.newSource("sound/blow-up-that-exekat-main-version-02-40-15156.mp3", "stream")
    Stage1 = love.graphics.newImage("stage1.jpg") -- Background image for 1st stage.
    P1 = Character(500, 30, 470, 120, 30, 100, 150, 250, 550, 100) -- Character instance
    Enemy = Enemy() -- Enemy instance.
    Titlescreen = love.graphics.newImage("titlescreen.jpg")
    GameName = love.graphics.newImage("gameName.png")
    GirlHurt = love.audio.newSource("sound/girlHurt.mp3", "static")
    Defeated = love.audio.newSource("sound/gameOver.mp3", "static")
    GameOverBanner = love.graphics.newImage("game_over_banner.png")

end

-- local variables used to change state and effects of character and deal with damange and delays.

local enemyPunchStart = false
local EnemyPunchCounter = 0
local P1damageCounter = 0
local enemydamangeCounter = 0
local delay = 1.5
local timeElapsed = 0
local deadTime = 0
GameStart = false
local score = 0
local gameOver = false
local formattedScore = "Score: %d"


function love.update(dt)
    Music:setVolume(0.4)
    love.audio.play(Music)

    if GameStart == true then
        P1:update(dt)
        Enemy:update(dt)
        Music:setVolume(0.2)
        GirlHurt:setVolume(0.5)
        

        -- Makes the enemy chase down the main character at a constant speed.
        if Enemy.x > P1.x and Enemy.dead == false then
            Enemy.walk = true
            Enemy.punch = false
            Enemy.facing = "left"
            Enemy.x = Enemy.x - 50 * dt
        else
            -- If the enemy reaches the character position, stop walking and set for fight. 
            Enemy.walk = false
            if timeElapsed < delay and Enemy.dead == false then
                Enemy.punch = false
                timeElapsed = timeElapsed + dt
                EnemyPunchCounter = 0
            elseif timeElapsed > delay and timeElapsed < delay + 0.3 and Enemy.dead == false then
                Enemy.punch = true
                timeElapsed = timeElapsed + dt
                EnemyPunchCounter = 1
            else
                Enemy.punch = false
                timeElapsed = 0
                EnemyPunchCounter = 0
            end
        end
        -- Enemy walks back if  player try to jump over. Re-sets the position relateive to the main character to avoid side switch.
        if Enemy.x < P1.x and P1.jumping == true then
            Enemy.punch = false
            Enemy.walk = true
            Enemy.x = P1.x
        end
        -- Starts Enemy punch state to deal damage to player.
        if Enemy.punch == true and EnemyPunch_currentFrame == 3 then
            enemyPunchStart = true
        end
        -- Sets the conditions for Enemy to be able to deal damage to player.
        if enemyPunchStart == true and P1.jab == false and EnemyPunchCounter == 1 and P1.jumping == false and P1.hp > 0 then
            P1.hurt = true
            P1damageCounter = 1
        -- Takes the damage from players health and resets state. 
        elseif P1damageCounter == 1 then
            P1.hurt = false
            Hurt(P1, Enemy)
            enemyPunchStart = false
            P1damageCounter = 0
            love.audio.play(GirlHurt)
        end
        -- Conditions for player to do deal damage to Enemy. Player and enemy X coordinate must be the same.
        if P1.jab == true and math.floor(P1.x) == math.floor(Enemy.x) and P1.jumping == false and P1.facing == "right" and Enemy.dead == false and Enemy.punch == false or
            P1.kick == true and math.floor(P1.x) == math.floor(Enemy.x) and P1.jumping == false and P1.facing =="right" and Enemy.dead == false and Enemy.punch == false then
        -- Sets the conditions for Enemy hurt animation if the player punches or kicks enemy.
            Enemy.hurt = true
            enemydamangeCounter = 1
        -- Counts and reduce the damage from Enemy health then reset the state of enemy back to normal minus the damange taken.
        elseif enemydamangeCounter == 1 and Enemy.dead == false then
            Enemy.hurt = false
            Enemy_Hurt(P1, Enemy)
            enemydamangeCounter = 0
            score = score + 50
        end
        -- Checks enemy health and changes the state to dead if health reaches 0.
        if Enemy.hp <= 0 then
            Enemy.dead = true
            Enemy.hurt = false
        end
        -- If Enemy dies, respawn the enemy with increased health each time the enemy is killed. reset it's x coordinates back to the original == when game launches.
        if Enemy.dead == true then
            if deadTime > 1 then
                Enemy.dead = false
                Enemy.hp = Enemy.startHp * Enemy.powerUp
                Enemy.x = Enemy.startX
                deadTime = 0
                Enemy.powerUp = Enemy.powerUp + 1
            else
                deadTime = deadTime + dt
            end
        end

        if P1.hp == 0 then
            P1.hurt = true
            Enemy.walk = false
            Enemy.punch = false
            for i = Music:getVolume(), 0, -0.008 do
                Music:setVolume(i)
            end
            love.audio.play(Defeated)
            gameOver = true
            love.timer.sleep(3)
            GameStart = false
        end
    --GameStart ends
    end

    if gameOver == true then
        P1.hp = -1
    end
--Update function ends
end

function love.draw()

    if GameStart == true and gameOver == false then
    -- Draw character's health bar
        love.graphics.draw(Stage1, 0, 0, 0, 0.7, 0.7)
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill",20, 20, P1.hp, 20)
        love.graphics.setColor(255,255,255,255)
        love.graphics.print("HP", 40, 40)

        --FPS meter
        love.graphics.print("FPS:"..tostring(love.timer.getFPS()), 700 , 5)

        --Score countrer
        love.graphics.print(string.format(formattedScore, score), 700, 25)

        P1.draw(P1)
        Enemy:draw()
    end

    -- Draws the Titlescreen
    if GameStart == false and gameOver == false then
        love.graphics.draw(Titlescreen, 0, 0, 0, 0.55, 0.41)
        love.graphics.draw(GameName, 80, 100, 0, 0.8, 0.8)
        local aKey = love.graphics.newImage("Keys/A-Key.png")
        local dKey = love.graphics.newImage("Keys/D-Key.png")
        local uKey = love.graphics.newImage("Keys/U-Key.png")
        local iKey = love.graphics.newImage("Keys/I-Key.png")
        local xKey = love.graphics.newImage("Keys/X-Key.png")
        local spaceKey = love.graphics.newImage("Keys/Space-Key.png")
        love.graphics.draw(xKey, 330, 270)
        love.graphics.print("START GAME", 380, 280)
        love.graphics.draw(aKey, 230, 340)
        love.graphics.print("MOVE LEFT", 280, 350)
        love.graphics.draw(dKey, 430, 340)
        love.graphics.print("MOVE RIGHT", 480, 350)
        love.graphics.draw(uKey, 330, 400)
        love.graphics.print("PUNCH", 370, 410)
        love.graphics.draw(iKey, 330, 430)
        love.graphics.print("KICK", 370, 440)
        love.graphics.draw(spaceKey, 330, 470)
        love.graphics.print("JUMP", 400, 480)
    end

    if gameOver == true then
        love.graphics.draw(GameOverBanner, 150, 100, 0, 0.8, 0.8)
        love.graphics.print(string.format(formattedScore, score), 350, 300)
        love.graphics.print("CREDITS:", 350, 400)
        love.graphics.print("Sound Track: #Uppbeat (free for Creators!): https://uppbeat.io/t/exekat/blow-up-that", 100, 430)
        love.graphics.print("License code: KF98KO9O8KHJOP9F", 100, 450)
        love.graphics.print("Control Keys Graphics: Gerald's Keys", 100, 480)
        love.graphics.print("Sprites source: opengameart.org", 100, 510)
        love.graphics.print("Sprites Attribution Notice: by ansimuz", 100, 530)
    end
end
-- Reduces the Player health by enemy punch amount for each enemy punch
function Hurt(P1, Enemy)
    P1.hp = P1.hp - Enemy.punchDamage
end
-- Reduces enemy health by player punch / kick amount for each player punch or kick.
function Enemy_Hurt(P1, Enemy)
    Enemy.hp = Enemy.hp - P1.punchDamage
end