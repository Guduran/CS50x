# CS50 Adventure Platformer
### Video Demo:  https://www.youtube.com/watch?v=Xw5pl9wik58
#### Description:
##### 1. boss.lua file
##### 2. camera.lua file
##### 3. coin.lua file
##### 4. conf.lua file
##### 5. enemy.lua file
##### 6. hud.lua file
##### 7. main.lua file
##### 8. map.lua file
##### 9. music.lua file
##### 10. player.lua file
##### 11. stone.lua file
##### 12. trap.lua file
##### 13. assets dir
##### 14. map dir

**1. boss.lua file:**
```
I created a local table to focus on game performance. Player and Music were required to verify the collisions and sound effects resulting from them.
Boss are placed in metatables that emulate classes, as different from the player, there can be more than one boss. The boss has speed, damage, rage
stuff and an offsetY to fix his height in the game. The boss has two animation patterns, walk when idle and run when rage. I had to decrease in shape
so that the collision was more accurate.
removeAll function for map change. getAssets function to load animation images. getPhysics function to set self.x, self.y and their speed.rage function
to enter rage mode when 3 collisions happen. turns function to change the character's direction of direction. setNewFrame function to change the getAssets
images. updateAll function to create bosses according to the map and use update for everyone. drawAll function for creating bosses according to the map and
using draw for all. function draw features scaleX and negative scaleX so that the character turns when changing direction, I changed the color to bring out
the character details and then went back to normal. firstContact function to check for collisions and if it happens to the player, a sound will play and
the player will lose 1 heart. Return Boss because it's local.
```
**2. camera.lua file:**
```
I created a local table to focus on game performance. main function push for copies and pushes the current coordinate transformation to the transformation
stack, scale for x and y equals to 2. translate has negative numbers to not let assets "fly". clear function uses pop as it is necessary since I used push
before. setFocus function with arguments x and y so that the camera focuses leaving the player in the middle, unless it is at the beginning or end of the
map. the width is divided by 2 because as the game focuses on the center of things, the center of the width is the width divided by 2. Return Camera
because it's local.
```
**3. coin.lua file:**
```
I created a local table to focus on game performance. Player and Music were required to verify the collisions and sound effects resulting from them.
Coin are placed in metatables that emulate classes. coins have their dimensions, and the image is static, as it doesn't use the same animation as the
characters. checkRemove function to see if toBeremoved is true and needs to be destroyed. remove function loops coins from the table and if the player
has collided with it it is destroyed from the map and removed from the table. spin function actually simulates an animation when a math attribute is
actually used to create a spin of the coin according to getTime times 2. removeAll function for map change. updateAll function to create coins according
to the map and use update for everyone. drawAll function for creating coins according to the map and using draw for all. firstContact function to check
for collisions and if it happens to the player, a sound will play and Plar:addCoins will be incremented. Return coin because it's local.
```
**4. conf.lua file:**
```
função love.conf contains the title of the game, the love version used, width and height of the window. console equal to true and vsync off.
```
**5. enemy.lua file:**
```
I created a local table to focus on game performance. Player and Music were required to verify the collisions and sound effects resulting from them.
Enemys are placed in metatables that emulate classes, as different from the player, there can be more than one enemy. The enemy has speed, damage, rage
stuff and an offsetY to fix his height in the game. The enemy has two animation patterns, walk when idle and run when rage. I had to decrease in shape
so that the collision was more accurate.
removeAll function for map change. getAssets function to load animation images. getPhysics function to set self.x, self.y and their speed.rage function
to enter rage mode when 3 collisions happen. turns function to change the character's direction of direction. setNewFrame function to change the getAssets
images. updateAll function to create enemies according to the map and use update for everyone. drawAll function for creating enemies according to the map and
using draw for all. function draw features scaleX and negative scaleX so that the character turns when changing direction, I changed the color to bring out
the character details and then went back to normal. firstContact function to check for collisions and if it happens to the player, a sound will play and
the player will lose 1 heart. Return Enemy because it's local.
```
**6. hud.lua file:**
```
I created a local table to focus on game performance. Player was required to use their current lives and coins. life and coin tables fixed at the corners
of the screen, and a font with size 18 and another with double that size. It is also described how to play in the center of the HUD. Return HUD because
it's local.
```
**7. main.lua file:**
```
Main require all files as well as its loads, getAssets, updates, updateAll, drawings, drawAll. love.keypressed function for the player to jump and play the
jump sound. first contact function with if return for static assets and without for dynamic ones. lastContact function to check if it is on the ground and
can perform jumps.
```
**8. map.lua file:**
```
Map requires almost all files. As well as the STI that I downloaded to help create maps with the Tiled program.
load function, to start a new world with 2000 gravity units and currentLevel = map1. boot function to start the map, if the current level is equal to 3 the
game was closing. Else STI is called and creates the world(level) , I had to set the visibility of some layers to false for the image to appear and not be
white. nextLevel function to destroy the level and load the next one resetting the player position. update function that takes the Player to the next level
when it exceeds the map width minus 16 which is the player's own width. clear function to destroy the entire level. getObjects function to create traps,
stones, enemies and bosses from where I put them in the Tiled program.
```
**9. music.lua file:**
```
I created a local table to focus on game performance. load function to create a backmusic(stream for music files) for the whole game and others songs(static
for short sounds effects) like coins, hurt, jump and roars. Some functions to play determined songs to be required in others files. Return music because
it's local.
```
**10. player.lua file:**
```
I created a local table to focus on game performance. Player has x and y locations for creation and start_x and y equal to x and y locations for later use.
player has its dimensions and speeds, as well as maximum speed, acceleration, friction, gravity, jumping power, lifes, if it's alive or not, if it's on the
ground and can perform a second jump. getHurts function to decrease your health and if it reaches zero the character dies. function die sets self.alive to
false. getRed function changing green and blue to zero to make the player red. getUncolor function to return the character's normal colors after the time
saved in self.color.speed. revive function to return the player to home position with resetPosition function which uses start_x and start_y mentioned above,
alive and with max lives. addCoins function to increase self.coins. Assets function to create motion, idle and jump animations. setState function to change
animations and set when the player is not on the ground is "jump", with x speed equal to 0 as "idle" and else as "move". function setDirection to change the
character's direction according to its x speed. setNewFrame and animate functions to create the animation effect. applyGravity function for the player to
descend when not on the ground. functions move and applyFriction for the movement of the character when pressing the right or left keys and applying friction
when not so that the player stops and doesn't keep sliding. fisrtContact function to check if it had contact with the ground and check by normal y if there
was a collision and if its y velocity should be 0. land function to detect the collision with the ground and release the double jump. jump function checks if
the "up" button was pressed and if it was on the ground or if it can take the second jump with 80% efficiency. lastContact function to know when the player
is not on the ground. draw function with the colors created on load and then return them to normal and scaleX to change the character's direction.
```
**11. stone.lua file:**
```
I created a local table to focus on game performance. Stone are placed in metatables that emulate classes. Stones have their dimensions, and the image is dynamic.
removeAll function for map change. updateAll function to create stones according to the map and use update for everyone. drawAll function for creating coins
according to the map and using draw for all. Return Stone because it's local.
```
**12. trap.lua file:**
```
I created a local table to focus on game performance. Traps are placed in metatables that emulate classes. Traps have their dimensions, and the image is static.
removeAll function for map change. updateAll function to create stones according to the map and use update for everyone. drawAll function for creating coins
according to the map and using draw for all. firstContact function to check for collisions and if it happens to the player, a sound will play andthe player will
lose 1 heart. Return Enemy because it's local.
```
**13. assets dir:**
```
In this directory contains the images to create the animations of the boss, the enemy, the player. inside sfx has the music and sound effects. As well as the
background sheet for creating tiles and the map in the Tiled program and the font used in the HUD.
```
**14. map dir:**
```
In this directory it contains the maps used by the game and in the tmx directory it has the.tmx files to edit the maps.
```
**15. sti dir:**
```
In this directory contains the necessary for the creation of maps. got on GitHub.
```