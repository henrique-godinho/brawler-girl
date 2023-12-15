Character = Object:extend()
local actionInputs = {
    jab = false,
    kick = false,
}

local punchSound = love.audio.newSource("sound/punch.mp3", "static")
local jumpShout = love.audio.newSource("sound/girlJump.mp3", "static")
local kickSound = love.audio.newSource("sound/kick.mp3", "static")


--Idle Spritesheets
P1_idle = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/idle.png")
local idleFrames = {}
idleFrames[1] = love.graphics.newQuad(0, 0, 93, 63, P1_idle:getDimensions())
idleFrames[2] = love.graphics.newQuad(96, 0, 93, 63, P1_idle:getDimensions())
idleFrames[3] = love.graphics.newQuad(192, 0, 93, 63, P1_idle:getDimensions())
idleFrames[4] = love.graphics.newQuad(288, 0, 93, 63, P1_idle:getDimensions())
-- To do: Change the variables to be idle related.
local idle_activeFrame
local idle_elapsedTime = 0
local idle_currentFrame = 1
--End of idle Spritesheets and variables

-- Walk Spritesheets
P1_walk = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/walk.png")
local walkFrames = {}
walkFrames[1] = love.graphics.newQuad(0, 0, 93, 63, P1_walk:getDimensions())
walkFrames[2] = love.graphics.newQuad(96, 0, 93, 63, P1_walk:getDimensions())
walkFrames[3] = love.graphics.newQuad(192, 0, 93, 63, P1_walk:getDimensions())
walkFrames[4] = love.graphics.newQuad(288, 0, 93, 63, P1_walk:getDimensions())
walkFrames[5] = love.graphics.newQuad(384, 0, 93, 63, P1_walk:getDimensions())
walkFrames[6] = love.graphics.newQuad(480, 0, 93, 63, P1_walk:getDimensions())
walkFrames[7] = love.graphics.newQuad(576, 0, 93, 63, P1_walk:getDimensions())
walkFrames[8] = love.graphics.newQuad(672, 0, 93, 63, P1_walk:getDimensions())
walkFrames[9] = love.graphics.newQuad(768, 0, 93, 63, P1_walk:getDimensions())
walkFrames[10] = love.graphics.newQuad(864, 0, 93, 63, P1_walk:getDimensions())
local walk_activeFrame
local walk_elapsedTime = 0
local walk_currentFrame = 1

--end of walk spritesheets

--Jump Spritesheets
P1_jump = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/jump.png")
local jumpFrames = {}
jumpFrames[1] = love.graphics.newQuad(0, 0, 93, 63, P1_jump:getDimensions())
jumpFrames[2] = love.graphics.newQuad(96, 0, 93, 63, P1_jump:getDimensions())
jumpFrames[3] = love.graphics.newQuad(192, 0, 93, 63, P1_jump:getDimensions())
jumpFrames[4] = love.graphics.newQuad(288, 0, 93, 63, P1_jump:getDimensions())
local jump_activeFrame
local jump_elapsedTime = 1
local jump_currentFrame = 0
--End of jump spritesheets and variables.


--Jab Spritesheets
P1_jab = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/jab.png")
local jabFrames = {}
jabFrames[1] = love.graphics.newQuad(0, 0, 93, 63, P1_jab:getDimensions())
jabFrames[2] = love.graphics.newQuad(96, 0, 93, 63, P1_jab:getDimensions())
jabFrames[3] = love.graphics.newQuad(192, 0, 93, 63, P1_jab:getDimensions())
local jab_elapsedTime = 0
local jab_currentFrame = 3
local jab_activeFrame = jabFrames[jab_currentFrame]
--End of jab spritessheets

-- Kick Spritesheets
P1_kick = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/kick.png")
local kickFrames = {}
kickFrames[1] = love.graphics.newQuad(0, 0, 96, 63, P1_kick:getDimensions())
kickFrames[2] = love.graphics.newQuad(96, 0, 96, 63, P1_kick:getDimensions())
kickFrames[3] = love.graphics.newQuad(192, 0, 96, 63, P1_kick:getDimensions())
kickFrames[4] = love.graphics.newQuad(288, 0, 96, 63, P1_kick:getDimensions())
kickFrames[5] = love.graphics.newQuad(384, 0, 96, 63, P1_kick:getDimensions())
local kick_elapsedTime = 0
local kick_currentFrame = 5
local kick_activeFrame = kickFrames[kick_currentFrame]
--End of Kick Spritesheets

-- Hurt Spritesheets
P1_Hurt = love.graphics.newImage("sprites/Spritesheets/Brawler Girl/hurt.png")
local hurtFrames = {}
hurtFrames[1] = love.graphics.newQuad(0, 0, 96, 63, P1_Hurt:getDimensions())
hurtFrames[2] = love.graphics.newQuad(96, 0, 96, 63, P1_Hurt:getDimensions())
local hurtFrames_elapsedTime = 0
local hurtFrames_currentFrames = 1
local hurtFrames_activeFrame = hurtFrames[hurtFrames_currentFrames]

--End of Upper Spritesheets

-- Create a character class with help of classic library.
function Character:new(hp, x, y, height, width, punch, kick, upper, ult, speed)
    self.hp = hp
    self.x = x
    self.y = y
    self.height = height
    self.width = width
    self.punchDamage = punch
    self.kickDamage = kick
    self.upper = upper
    self.ult = ult
    self.speed = speed
    self.jumping = false
    self.jumpSpeedY = 150
    self.initialJumpSpeedY = 150
    self.jumpSpeedX = 150
    self.initialJumpSpeedX = 100
    self.onGround = true
    self.facing = "right"
    self.walk = false
    self.jab = false
    self.kick = false
    self.punchActive = 0
    self.canjab = false
    self.cankick = false
    self.uppercut = false
    self.canupper = false
    self.hurt = false
end



function Character:update(dt)
-- Character walk to the right
    if love.keyboard.isDown("d") and self.x <= 750 and self.jumping == false and math.floor(self.x) < math.floor(Enemy.x) then
        self.x = self.x + (self.speed * dt)
        self.facing = "right"
        self.walk = true
    else
        self.walk = false
    end

-- Character walk to the left
    if love.keyboard.isDown("a") and self.x > 10 and self.jumping == false and self.hurt == false then
        self.x = self.x - (self.speed * dt)
        self.facing = "left"
        self.walk = true
    end

-- Character jumping to the right
    if love.keyboard.isDown("d") and self.x <= 750 and self.jumping == true then
        P1.y = P1.y - P1.jumpSpeedY * dt
        P1.jumpSpeedY = P1.jumpSpeedY - 120 * dt
        P1.x = P1.x + P1.jumpSpeedX * dt
        P1.jumpSpeedX = P1.jumpSpeedX - (5*dt)
        self.facing = "right"
    end
-- Character jumping to the left
    if love.keyboard.isDown("a") and self.x > 10 and self.jumping == true then
        P1.y = P1.y - P1.jumpSpeedY * dt
        P1.jumpSpeedY = P1.jumpSpeedY - 120 * dt
        P1.x = P1.x - P1.jumpSpeedX * dt
        P1.jumpSpeedX = P1.jumpSpeedX - (5*dt)
        self.facing = "left"
    end

-- Character neutral jump.
    if self.jumping == true then
        P1.y = P1.y - P1.jumpSpeedY * dt
        P1.jumpSpeedY = P1.jumpSpeedY - (120 * dt)
    end
--Check if character is on the ground
    if P1.y > 470 then
        P1.y = 470
        P1.jumping = false
        P1.onGround = true
    end

    --Idle animation
    if self.onGround == true then
        idle_elapsedTime = idle_elapsedTime + dt
        if idle_elapsedTime > 0.3 then
            if idle_currentFrame < 4 then
                idle_currentFrame = idle_currentFrame + 1
            else
                idle_currentFrame = 1
            end
            idle_activeFrame = idleFrames[idle_currentFrame]
            idle_elapsedTime = 0
        end
        idle_activeFrame = idleFrames[idle_currentFrame]
    end
    --Idle animation

    -- walk animation
    if self.onGround == true then
        walk_elapsedTime = walk_elapsedTime + dt
        if walk_elapsedTime > 0.3 then
            if walk_currentFrame < 4 then
                walk_currentFrame = walk_currentFrame + 1
            else
                walk_currentFrame = 1
            end
            walk_activeFrame = walkFrames[walk_currentFrame]
            walk_elapsedTime = 0
        end
        walk_activeFrame = walkFrames[walk_currentFrame]
    end

    --jump animation
    if self.onGround == false then
        jump_elapsedTime = jump_elapsedTime + dt
        if jump_elapsedTime > 0.1 then
            if jump_currentFrame < 4 then
                jump_currentFrame = jump_currentFrame + 1
            else
                jump_currentFrame = 4
            end
            jump_activeFrame = jumpFrames[jump_currentFrame]
            jump_elapsedTime = 0
        end
    else
        jump_currentFrame = 1
    end
    -- end of jump animation

    -- jab animation
    if self.jab then
        jab_elapsedTime = jab_elapsedTime + dt
        if jab_elapsedTime > 0.1 then
            jab_activeFrame = jabFrames[jab_currentFrame]
            jab_elapsedTime = 0
            self.jab = false
        end
    else
        if actionInputs.jab then
            if self.canjab then
                self.jab = true
                self.canjab = false
                self.punchActive = love.timer.getTime()
            end
        else
            self.canjab = true
        end
    end
    --end of jab animation

    -- kick animation
    if self.kick then
        kick_elapsedTime = kick_elapsedTime + dt
        if kick_elapsedTime > 0.1 then
            kick_activeFrame = kickFrames[kick_currentFrame]
            kick_elapsedTime = 0
            self.kick = false
        end
    else
        if actionInputs.kick then
            if self.cankick then
                self.kick = true
                self.cankick = false
                self.kickActive = love.timer.getTime()
            end
        else
            self.cankick = true
        end
    end
    --end of kick animation

    --hurt Animation
    if self.hurt == true then
        hurtFrames_elapsedTime = hurtFrames_elapsedTime + dt
        if hurtFrames_elapsedTime > 0.1 then
            if hurtFrames_currentFrames < 2 then
                hurtFrames_currentFrames = hurtFrames_currentFrames + 1
            else
                hurtFrames_currentFrames = 2
            end
            hurtFrames_activeFrame = hurtFrames[hurtFrames_currentFrames]
        end
        hurtFrames_activeFrame = hurtFrames[hurtFrames_currentFrames]
    end

--function update() ends
end

function Character:draw()
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height) -- reference position.

    --idle sprite facing right
    if self.onGround == true and self.facing == "right" and self.walk == false and self.jab == false and self.kick == false and self.hurt == false then
        love.graphics.draw(P1_idle, idle_activeFrame, self.x, self.y, 0, 2.3, 2.3, self.width + 5, self.height -110)
    end

    --idle sprite facing left
    if self.onGround == true and self.facing == "left" and self.walk == false and self.jab == false and self.kick == false and self.hurt == false then
        love.graphics.draw(P1_idle, idle_activeFrame, self.x + 200, self.y, 0, -2.3, 2.3, self.width -65, self.height -110)
    end

    --Walk sprite walking right
    if love.keyboard.isDown("d") and self.x <= 750 and self.onGround == true and self.facing == "right" and self.walk == true and self.jab == false and self.kick == false then
        love.graphics.draw(P1_walk, walk_activeFrame,self.x, self.y, 0, 2.3, 2.3, self.width + 5, self.height -110)
    end

    --Walk sprite walking left
    if love.keyboard.isDown("a") and self.x > 10 and self.onGround == true and self.facing == "left" and self.walk == true and self.jab == false and self.kick == false then
        love.graphics.draw(P1_walk, walk_activeFrame,self.x + 200, self.y, 0, -2.3, 2.3, self.width -65, self.height -110)
    end

    --jump sprite jumping right
    if self.onGround == false and self.facing == "right" and self.jab == false and self.kick == false then
        love.graphics.draw(P1_jump, jump_activeFrame, self.x, self.y, 0, 2.3, 2.3, self.width, self.height -110)
    end
    -- jump sprite jumping left
    if self.onGround == false and self.facing == "left" and self.jab == false and self.kick == false then
        love.graphics.draw(P1_jump, jump_activeFrame, self.x + 200, self.y, 0, -2.3, 2.3, self.width -65, self.height -110)
    end

    --jab sprite jabbing right
    if self.facing == "right" and self.jab == true and self.kick == false and (love.timer.getTime() - self.punchActive) < 0.5 and self.hurt == false then
        love.graphics.draw(P1_jab, jab_activeFrame, self.x, self.y + 30, 0, 2.3, 2.3, (self.width * 1.2) + 5, 23)
    end

    --jab sprite jabbing left
    if self.facing == "left" and self.jab == true and self.kick == false and (love.timer.getTime() - self.punchActive) < 0.1  then
        love.graphics.draw(P1_jab, jab_activeFrame, self.x, self.y + 30, 0, -2.3, 2.3, (self.width *1.2) +20, 23)
    end

    --kick sprite kicking right
    if self.facing == "right" and self.kick == true and (love.timer.getTime() - self.kickActive) < 0.5 and self.hurt == false then
        love.graphics.draw(P1_kick, kick_activeFrame, self.x, self.y + 30, 0, 2.3, 2.3, (self.width * 1.2), 23)
    end

  --kick sprite kicking left
    if self.facing == "left" and self.kick == true and (love.timer.getTime() - self.kickActive) < 0.1 then
        love.graphics.draw(P1_kick, kick_activeFrame, self.x, self.y + 30, 0, -2.3, 2.3, (self.width * 1.2) + 15, 23)
    end

    --hurt sprite
    if self.hurt == true then
        love.graphics.draw(P1_Hurt, hurtFrames_activeFrame, self.x, self.y, 0, 2.3, 2.3, (self.width * 1.2), 23)
    end

--Draw() function end
end

function love.keypressed(key, isrepeat)
-- Jump conditions. Character can only jump if on the ground
    if key == "space" and P1.onGround and GameStart == true then
        P1.jumping = true
        P1.onGround = false
        P1.jumpSpeedY = P1.initialJumpSpeedY
        P1.jumpSpeedX = P1.initialJumpSpeedX
        love.audio.play(jumpShout)
    end
-- Character punch mechanics
    if key == "u" and GameStart == true then
        actionInputs.jab = true
        love.audio.play(punchSound)
    end
-- Character kick mechanics.
     if key == "i" and GameStart == true then
        actionInputs.kick = true
        love.audio.play(kickSound)
     end

     if key == "x" then
        GameStart = true
     end
end

function love.keyreleased(key)
    if key == "u" then
        actionInputs.jab = false
    end

    if key == "i" then
        actionInputs.kick = false
    end
end

