-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created By: Amin Zeina
-- Created On: Apr 2018
--
-- Game where you must shoot the enemy before he shoots you.
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

-- enable physics
local physics = require( 'physics' )
physics.start()

-- set up GUI
local background = display.newImageRect( './assets/sprites/BG.png', 2048, 1536 )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "zombie"

local robot = display.newImageRect( './assets/sprites/robot.png', 567, 566 )
robot.x = 300
robot.y = 1000
physics.addBody( robot, "static" )
robot.gravityScale = 0
robot.id = "robot"

local zombie = display.newImageRect( './assets/sprites/zombie.png', 430, 519 )
zombie.x = 1700
zombie.y = 1000
zombie.xScale = -1
physics.addBody( zombie, "static" )
zombie.gravityScale = 0
zombie.id = "zombie"
zombie.alpha = 1

local shootButton = display.newImageRect( './assets/sprites/shootButton.png', 300, 300 )
shootButton.x = 200
shootButton.y = 1300
shootButton.alpha = 0.9
shootButton.id = "shootButton"

local explosion = display.newImageRect( './assets/sprites/explosion.png', 200, 200 )
explosion.x = 375
explosion.y = 975
explosion.alpha = 0
explosion.id = "explosion"

local explosionSound = audio.loadSound( './assets/audio/Explosion.mp3')
audio.setVolume( 0.3 )

local function onShootClicked( event )
	local bullet = display.newImageRect( './assets/sprites/bullet.jpg', 200, 200 )
	bullet.x = 375
	bullet.y = 975
	bullet.alpha = 0
	local function addPhysicsToBullet( event )
		-- adding physics to bullet2 with delay
		physics.addBody( bullet,"dynamic" )
		bullet.gravityScale = 0
	end
	timer.performWithDelay( 500, addPhysicsToBullet ) -- delay ensures the bullet doesn't collide with itself(robot)
	bullet.id = "bullet"

	transition.fadeIn( bullet, { time=100 } )
	-- move bullet
	transition.moveTo( bullet, { x=1700, y=1000, time=2000 } )
	
	-- fade out bullet 
	local function fadeBullet( event )
		transition.fadeOut( bullet, { time=100 } )
	end
	timer.performWithDelay( 2000, fadeBullet )
end

if zombie.alpha == 1 then 
	for timesShot = 1, 10, 1 do
		local function zombieShooting( event )
			-- create bullet2 sprite
			local bullet2 = display.newImageRect( './assets/sprites/bullet2.png', 200, 200 )
			bullet2.x = 1675
			bullet2.y = 1000
			bullet2.xScale = -1
			bullet2.alpha = 0
			local function addPhysicsToBullet2( event )
				-- adding physics to bullet2 with delay
				physics.addBody( bullet2,"dynamic" )
				bullet2.gravityScale = 0
			end
			timer.performWithDelay( 700, addPhysicsToBullet2 ) -- delay ensures the bullet doesn't collide with itself(zombie)
			bullet2.id = "bullet2"
			
			-- show bullet2
			transition.fadeIn( bullet2, { time=100 } )
			-- move bullet2
			transition.moveTo( bullet2, { x=300, y=1000, time=2000 } )
			-- fade out bullet2 
			local function fadeBullet2( event )
				transition.fadeOut( bullet2, { time=100 } )
			end
			timer.performWithDelay( 2000, fadeBullet2 )
		end
		-- wait 5 seconds before shooting
		timer.performWithDelay( 5000, zombieShooting )
	end
end



local function onRobotHit( event )
	-- fade out robot
	transition.fadeOut( robot, { time=100 } )

	local explosion = display.newImageRect( './assets/sprites/explosion.png', 500, 500 )
	explosion.x = 300
	explosion.y = 1000
	explosion.alpha = 0
	explosion.id = "explosion"

	-- show explosion
	transition.fadeIn( explosion, { time=100 } )
	-- play explosion sound
	audio.play(explosionSound)

	local loseText = display.newText( 'You Lose!', display.contentCenterX, 350, native.systemFont, 200)
	loseText:setFillColor( 1, 0, 0)
end

local function onZombieHit( event )
	-- fade out robot
	transition.fadeOut( zombie, { time=100 } )

	local explosion2 = display.newImageRect( './assets/sprites/explosion.png', 500, 500 )
	explosion2.x = 1700
	explosion2.y = 1000
	explosion2.alpha = 0
	explosion2.id = "explosion2"

	-- show explosion
	transition.fadeIn( explosion2, { time=100 } )
	-- play explosion sound
	audio.play(explosionSound)

	local winText = display.newText( 'You Win!', display.contentCenterX, 350, native.systemFont, 200)
	winText:setFillColor( 1, 0, 1)
end

zombie:addEventListener( 'collision', onZombieHit )
robot:addEventListener( 'collision', onRobotHit )
shootButton:addEventListener( 'touch', onShootClicked )