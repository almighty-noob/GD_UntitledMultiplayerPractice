THIS PROJECT HAS BEEN PUT ON HOLD INDEFINITELY

The application relies on P2P connections to enable multiplayer. 
<br/>
**IMPORTANT: The P2P connection does not use UPnP, instead the host needs to enable port forwarding on the specified port. This can be changed in /Scripts/world.gd using the const PORT**


**<h3>Game Mechanics</h3>**

Input keys can be defined within the Engine and are fully customizable for K&M or Controllers.
<br/>
<br/>

**Basic Actions:** <br/>
1. Each player can move left or right using Movement keys.<br/>
2. Each player can use the jump key to gain height. If the first jump is launched off the ground then an optional second jump can be activated mid-air once.<br/>
3. Each player can use the dash key to propel forward a short distance with a burst of speed one time. Touching the ground will reset this cooldown. <br/>
4. Aim using the Mouse and shoot with the Fire button.<br/>
5. Players also have the option to perform a wall jump for extra horizontal speed greater than the normal movement. This is done by pressing the opposite directional key when a player is close to or touching a wall. <br/>

**Guns:** <br/>
The game has 3 guns as of now. <br/>
1. Pistol: Medium Fire Rate, Full Range, Medium Damage, Medium Reload Time, Medium Magazine size<br/>
2. Revolver: Slow Fire Rate, Full Range, High Damage, Slow Reload Time, Small Magazine size<br/>
3. SMG: Fast Fire Rate, Limited Range, Low Damage, Fast Reload Time, Large Magazine size<br/>
Weapons can be switched with a fixed cooldown that can be defined with the timer within the engine or in GUn.gd <br/>

**Additional Info:**
While fast bullets appear on the screen, they are merely cosmetic. The bullet hits are handled via hitscan instead by using a raycast that originates from the player than looks towards the mouse position.<br/>
Two instances of the game can be opened for testing and using "localhost" in place of address can allow local multiplayer.
<br/>
If port forwarding is not available then a virtual network such as Hamachi can be used by the peers to connect to, although this may introduce unwanted lag. 
