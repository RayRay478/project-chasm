# "SEGASONIC CHASM"

 *A low-poly asymmetrical survival horror multiplayer game based on internet oddities found in Sonic the Hedgehog. An anomalous, paradigmless event has shattered the multiversal boundaries of the known and unknown, casting Sonic and his friends into a twisted helix between worlds - where beings beyond rhyme or reason lurk.*

-#  *Large focus on low-polygonal limitations; Sonic World mode from Sonic Jam being the main inspiration for the gameplay loop and it's physics.*

This project is a 3D Sonic-inspired platformer developed in Godot, focusing on momentum-based movement and terrain interaction. The codebase utilizes inheritance, reusable components, and a shared animation framework to support multiple playable characters while maintaining a centralized movement system. Current features include traction-based movement, velocity-preserving jumps, slope physics, and state-driven animation control.
## 📁 Directory Structure

```text
res://
├── addons/                          # Godot addons and plugins
│
├── audio/                           # Music and sound effects
│
├── entity/
│   ├── CHARACTERS/
│   │   ├── Absolutes/               # Playable character scenes
│   │   └── UNUSED/                  # Deprecated or experimental characters
│   │
│   ├── componets/                   # Shared character/gameplay components
│   └── CharacterSpawner.tscn        # Character spawning system
│
├── fonts/                           # UI fonts and typography assets
│
├── model/
│   ├── blendfiles/                  # Blender source files
│   ├── gobot/                       # Main character/environment models
│   ├── otherstages/                 # Stage-specific models
│   ├── UNUSED+RANDOM/               # Unused assets and prototypes
│   ├── TripWiremat.tres             # Material resource
│   └── TripwireUpdate.fbx           # Imported FBX asset
│
├── scene/                           # Game scenes and levels
│
├── scripts/
│   ├── character-scripts/           # Character-specific behavior
│   ├── editor/                      # Editor tools and utilities
│   ├── player/                      # Shared player systems
│   ├── buttons.gd                   # UI button logic
│   ├── global.gd                    # Global game manager
│   ├── network.gd                   # Multiplayer/networking
│   ├── SpeedBooster.gd              # Speed booster mechanics
│   └── ui.gd                        # UI controller
│
├── script_templates/                # Custom script templates
│
├── textures/                        # Texture assets
│
└── ui/                              # User interface scenes and assets
```
