# Artillery Hell

[Showcase Video](https://youtu.be/8hG2pc_2XhE)

Artillery Hell is a tank-based roguelike fought over an ever-shifting land.  
Progress through interesting terrains with your tank, defeat enemies in your way, and 
amass upgrades that stack and interact with each other in a variety of ways to construct the ultimate weapon of war. 

--------------------------------------------------------------------
## Gameplay

<b>General Progression: </b>

- 20 levels with increasing amounts of enemies that get stronger and become harder to kill 
  - Levels are completed when all enemies in a wave have been defeated 
- Tank upgrade system allows the Player to increase one of three stats: 
  - Attack by 5 
  - HP by 10 
  - Move Speed by 20 

<b>Player Actions: </b>

- Control tank using ‘WASD’ keys on keyboard 
  - W and S control forward and backward motion 
  - A and D control left and right rotation 
- Roam around an enclosed map area 
- Shoot damaging bullets using the ‘spacebar’ 
- Dies if health bar runs out 

<b>Enemy Actions: </b>

- Tank enemies can:  
  - Lock onto and shoot damaging bullets at the Player once their aggro range is entered 
  - Only receive damage from the front of the tank, just like the Player 
  - Receive an increase of 20 to health and movement speed with every 2 waves completed by the Player 
  - Receive an increase of 1 to attack with every wave completed, and an increase of 5 to attack with every 5 waves completed 
- Plane enemies can: 
  - Not lock onto the player 
  - Shoot missiles in doubles that home onto the player if the player enters their aggro range (which is larger than enemy tanks) 
  - Receive an increase of 40 to health and 20 to movement speed with every 2 waves completed by the Player 
  - Receive an increase of 1 to attack with every wave completed, and an increase of 5 to attack with every 5 waves completed 
- Both enemy types roam the map and die when their hp runs out

--------------------------------------------------------------------
## User Interface (UI) 

- Main menu with Play, Help, and Quit button 
- Player HUD 
  - The Player’s health bar, Enemy Count, and Current Level are all listed at the top left of the Player’s viewport 
  - Mini map located at the top right 
- Enemy HUD 
  - Once the player damaged an enemy, a small health bar will appear above them, showcasing their current HP 
- Player Upgrade Menu, which is available in between each wave completion 
  - Player stats listed on left side 
    - HP, Attack, and Tank Movement Speed (Upgradable) 
    - Gun Cooldown, Bullet Speed, and Tank Rotation Speed (Non-upgradable) 
  - Player must select at least 1 upgrade before the confirm button appears 

--------------------------------------------------------------------
## VFX & SFX 

- VFX
  - Explosive effects when bullets explode 
  - Explosion effect when an enemy tank explodes 
  - Slight gun recoil effect on all tanks when shooting bullets 
  - Plane missiles have a trailing particle effect 
- SFX
  - Main soundtrack that plays throughout the game 
  - Unique sound effects for when tanks are damaged vs. when tanks are hit from the side 
  - Unique shooting sound effect for Player and Enemies

--------------------------------------------------------------------
## Credits
- Rodrick Moore – Main Programmer
- Josh Cohen – Gameplay Direction, Planning, Element tuning and sound effects work
- Zhou Shengcu – Visual and Audio Designer
- Credits to [Kenny Assets](https://kenney.nl/assets) for the map tile set, bullet sprites, and various UI elements. 
- Credits to [samoliver](https://opengameart.org/users/samoliver) for the assets used for the missile smoke trail effect. 
- Credits to [KidsCanCode](https://www.youtube.com/@Kidscancode) for the amazing Top-down Tank Battle tutorials, which were a huge help with getting accustomed to Godot. 
