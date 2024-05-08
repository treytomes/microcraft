import "importUtil"
ensureImport "events"
ensureImport "listUtil"
ensureImport "qa"

ensureImport "coreUtil"

// Note how system-defined symbols can be extended.
env.addImportPath = function(path)
    // `self` == `env`
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./crafting"
env.addImportPath "./entity"
env.addImportPath "./entity/particle"
env.addImportPath "./gfx"
env.addImportPath "./item"
env.addImportPath "./item/resource"
env.addImportPath "./level"
env.addImportPath "./level/levelgen"
env.addImportPath "./level/tile"
env.addImportPath "./screen"
env.addImportPath "./sound"

globals.Random = require("Random")

// gfx
globals.Color = require("Color")
globals.Font = require("Font")
globals.Screen = require("Screen")
globals.Sprite = require("Sprite")
globals.SpriteSheet = require("SpriteSheet")

// screen
globals.ListItem = require("ListItem")

// level/levelgen
globals.LevelGen = require("LevelGen")

// entity
globals.Entity = require("Entity")
globals.Furniture = require("Furniture")
globals.Inventory = require("Inventory")
globals.ItemEntity = require("ItemEntity")
globals.Mob = require("Mob")
globals.AirWizard = require("AirWizard")
globals.Anvil = require("Anvil")
globals.Chest = require("Chest")
globals.Furnace = require("Furnace")
globals.Lantern = require("Lantern")
globals.Oven = require("Oven")
globals.Player = require("Player")
globals.Slime = require("Slime")
globals.Spark = require("Spark")
globals.Workbench = require("Workbench")
globals.Zombie = require("Zombie")

// item
globals.ToolType = require("ToolType")
globals.Item = require("Item")
globals.FurnitureItem = require("FurnitureItem")
globals.PowerGloveItem = require("PowerGloveItem")
globals.ResourceItem = require("ResourceItem")
globals.ToolItem = require("ToolItem")

// level/tile
globals.Tile = require("Tile")
globals.CactusTile = require("CactusTile")
globals.CloudCactusTile = require("CloudCactusTile")
globals.CloudTile = require("CloudTile")
globals.DirtTile = require("DirtTile")
globals.FarmTile = require("FarmTile")
globals.GrassTile = require("GrassTile")
globals.FlowerTile = require("FlowerTile")
globals.HardRockTile = require("HardRockTile")
globals.HoleTile = require("HoleTile")
globals.InfiniteFallTile = require("InfiniteFallTile")
globals.LavaTile = require("LavaTile")
globals.OreTile = require("OreTile")
globals.RockTile = require("RockTile")
globals.SandTile = require("SandTile")
globals.SaplingTile = require("SaplingTile")
globals.StairsTile = require("StairsTile")
globals.StoneTile = require("StoneTile")
globals.TreeTile = require("TreeTile")
globals.WaterTile = require("WaterTile")
globals.WheatTile = require("WheatTile")

// item/source
// TODO: I'm expecting a circular dependency here.  Might need a factory initializer for recipes and resouces.
globals.Resource = require("Resource")
globals.FoodResource = require("FoodResource")
globals.PlantableResource = require("PlantableResource")

ensureImport("items")

// crafting
globals.Recipe = require("Recipe")
globals.FurnitureRecipe = require("FurnitureRecipe")
globals.ResourceRecipe = require("Recipe")
globals.ToolRecipe = require("ToolRecipe")
globals.Crafting = require("Crafting")

// entity/particle
globals.Particle = require("Particle")
globals.SmashParticle = require("SmashParticle")
globals.TextParticle = require("TextParticle")

// sound
globals.Sounds = require("Sounds") // Had to rename this one to avoid naming conflicts.

// level
globals.Level = require("Level")

// screen
globals.Menu = require("Menu")
globals.AboutMenu = require("AboutMenu")
globals.ContainerMenu = require("ContainerMenu")
globals.CraftingMenu = require("CraftingMenu")
globals.DeadMenu = require("DeadMenu")
globals.InstructionsMenu = require("InstructionsMenu")
globals.InventoryMenu = require("InventoryMenu")
globals.LevelTransitionMenu = require("LevelTransitionMenu")
globals.TitleMenu = require("TitleMenu")
globals.WonMenu = require("WonMenu")

globals.InputHandler = require("InputHandler")
globals.Game = require("Game")





image = file.loadImage("assets/icons.png")

sheet = (new SpriteSheet).make(image)

screen = (new Screen).make(Game.WIDTH, Game.HEIGHT, sheet)

titleMenu = (new TitleMenu).make
titleMenu.render screen

colors = Game.getColors

for y in range(0, screen.h - 1)
    for x in range(0, screen.w - 1)
        cc = screen.pixels[x + y * screen.w]
        // Immediately draw to the PixelDisplay.
        // TODO: I'm ignoring the *3 scale for the moment.
        if cc < 255 then
            gfx.setPixel x, screen.h - y - 1, colors[cc]
        else
            // TODO: This bit might not be needed.
            // gfx.setPixel x, y, color.black
            gfx.setPixel x, screen.h - y - 1, color.red
        end if
    end for
end for