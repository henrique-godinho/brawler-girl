Enemy = Object:extend()
require "character"

local hitSound = love.audio.newSource("sound/thump.mp3", "static")
local deadSound = love.audio.newSource("sound/dead.mp3", "static")

-- Idle Spritesheets
EnemyIdle = love.graphics.newImage("sprites/Spritesheets/Enemy Punk/idle.png")
local enemyIdle_frames = {}
enemyIdle_frames[1] = love.graphics.newQuad(0,0,96,63, EnemyIdle:getDimensions())
enemyIdle_frames[2] = love.graphics.newQuad(96, 0, 96,63, EnemyIdle:getDimensions())
enemyIdle_frames[3] = love.graphics.newQuad(192, 0, 96, 63, EnemyIdle:getDimensions())
enemyIdle_frames[4] = love.graphics.newQuad(288, 0, 96, 63, EnemyIdle:getDimensions())

local enemyIdle_activeFrame
local enemyIdle_elapsedTime = 0
local enemyIdle_currentFrame = 1

-- Walk spritesheets
EnemyWalk = love.graphics.newImage("sprites/Spritesheets/Enemy Punk/walk.png")
local enemyWalk_frames = {}
enemyWalk_frames[1] = love.graphics.newQuad(0,0,96,63, EnemyWalk:getDimensions())
enemyWalk_frames[2] = love.graphics.newQuad(96, 0, 96,63, EnemyWalk:getDimensions())
enemyWalk_frames[3] = love.graphics.newQuad(192, 0, 96, 63, EnemyWalk:getDimensions())
enemyWalk_frames[4] = love.graphics.newQuad(288, 0, 96, 63, EnemyWalk:getDimensions())

local enemyWalk_activeFrame
local enemyWalk_elapsedtime = 0
local enemyWalk_currentFrame = 1

-- Punch Spritesheets
EnemyPunch = love.graphics.newImage("sprites/Spritesheets/Enemy Punk/punch.png")
local enemyPunch_frames = {}
enemyPunch_frames[1] = love.graphics.newQuad(0,0,96,63, EnemyPunch:getDimensions())
enemyPunch_frames[2] = love.graphics.newQuad(96, 0, 96,63, EnemyPunch:getDimensions())
enemyPunch_frames[3] = love.graphics.newQuad(192, 0, 96, 63, EnemyPunch:getDimensions())

local enemyPunch_activeFrame = 1
local enemyPunch_elapsedtime = 0
EnemyPunch_currentFrame = 1

-- Hurt Spritesheets
EnemyHurt = love.graphics.newImage("sprites/Spritesheets/Enemy Punk/hurt.png")
local enemyHurt_frames = {}
enemyHurt_frames[1] = love.graphics.newQuad(0,0,96,63, EnemyHurt:getDimensions())
enemyHurt_frames[2] = love.graphics.newQuad(96, 0, 96,63, EnemyHurt:getDimensions())
enemyHurt_frames[3] = love.graphics.newQuad(192, 0, 96, 63, EnemyHurt:getDimensions())
enemyHurt_frames[4] = love.graphics.newQuad(288, 0, 96, 63, EnemyHurt:getDimensions())

local enemyHurt_activeFrame = 1
local enemyHurt_elapsedtime = 0
local enemyHurt_currentFrame = 1

-- Constructor
function Enemy:new()
    self.startX = 500
    self.startHp = 300
    self.powerUp = 1
    self.x = 500
    self.y = 445
    self.hp = 300
    self.height = 100
    self.punchDamage = 50
    self.speed = 50
    self.walk = true
    self.idle = false
    self.facing = "left"
    self.punch = false
    self.hurt = false
    self.dead = false
end


function Enemy:update(dt)

    -- idle animation
    enemyIdle_elapsedTime = enemyIdle_elapsedTime + dt
        if enemyIdle_elapsedTime > 0.2  then
            if enemyIdle_currentFrame < 4 then
                enemyIdle_currentFrame = enemyIdle_currentFrame + 1
            else
                enemyIdle_currentFrame = 1
            end
            enemyIdle_activeFrame = enemyIdle_frames[enemyIdle_currentFrame]
            enemyIdle_elapsedTime = 0
        end
        enemyIdle_activeFrame = enemyIdle_frames[enemyIdle_currentFrame]
    --end of idle animation

    -- walking animation
    enemyWalk_elapsedtime = enemyWalk_elapsedtime + dt
        if enemyWalk_elapsedtime > 0.1 then
            if enemyWalk_currentFrame < 4 then
                enemyWalk_currentFrame = enemyWalk_currentFrame + 1
            else
                enemyWalk_currentFrame = 1
            end
            enemyWalk_activeFrame = enemyWalk_frames[enemyWalk_currentFrame]
            enemyWalk_elapsedtime = 0
        end
        enemyWalk_activeFrame = enemyWalk_frames[enemyWalk_currentFrame]
    -- end of walking animation

    -- punch animation
    if self.punch == true then
        enemyPunch_elapsedtime = enemyIdle_elapsedTime + dt
        if enemyPunch_elapsedtime > 0.2 then
            if EnemyPunch_currentFrame < 3 then
                EnemyPunch_currentFrame = EnemyPunch_currentFrame + 1
            elseif enemyPunch_elapsedtime > 0.7 then
                EnemyPunch_currentFrame = 1
            end
        end
        enemyPunch_activeFrame = enemyPunch_frames[EnemyPunch_currentFrame]
    end

    -- hurt / dead animation
    if self.hurt == true then
        enemyHurt_elapsedtime = enemyHurt_elapsedtime + dt
        if enemyHurt_elapsedtime > 0 then
            enemyHurt_currentFrame = 2
        end
        enemyHurt_activeFrame = enemyHurt_frames[enemyHurt_currentFrame]
        love.audio.play(hitSound)
    elseif self.dead == true then
        if enemyHurt_currentFrame < 4 then
            enemyHurt_currentFrame = enemyHurt_currentFrame + 1
        else
            enemyHurt_currentFrame = 4
        end
        enemyHurt_activeFrame = enemyHurt_frames[enemyHurt_currentFrame]
        love.audio.play(deadSound)
    end
-- Update function ends
end

function Enemy:draw()
    -- Enemy Idle
    if self.walk == false and self.facing == "left" and self.punch == false and self.hurt == false and self.dead == false then
        love.graphics.draw(EnemyIdle, enemyIdle_activeFrame, self.x, self.y, 0, 2.3, 2.3)
    end

    -- Enemy waling
    if self.walk == true and self.facing == "left" and self.punch == false and self.hurt == false and self.dead == false then
    love.graphics.draw(EnemyWalk, enemyWalk_activeFrame, self.x, self.y, 0, 2.3, 2.3)
    end

    --Enemy punch
    if self.punch == true and self.facing == "left" and self.dead == false then
        love.graphics.draw(EnemyPunch, enemyPunch_activeFrame, self.x, self.y, 0, 2.3, 2.3)
    end

    --Enemy hurt / dead
    if self.hurt == true or self.dead == true then
        love.graphics.draw(EnemyHurt, enemyHurt_activeFrame, self.x, self.y, 0, 2.3, 2.3)
    end
end
