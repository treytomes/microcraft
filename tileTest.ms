import "importUtil"
ensureImport "events"
ensureImport "listUtil"
ensureImport "stringUtil"
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
// TODO: I'm expecting a circular dependency here.  Might need a factory initializer for recipes and resources.
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

tileGeneratorDisplay = new PixelDisplay
tileGeneratorDisplay.clear color.orange, 8192, 8
tileGeneratorDisplay.numTiles = 0
tileGeneratorDisplay.tileWidth = 8
tileGeneratorDisplay.tileHeight = 8

// @returns {int} The index of your tile.
tileGeneratorDisplay.generateTile = function(sheet, tile, colors, bits=0)
    xp = self.numTiles * self.tileWidth
    yp = 0
    mirrorX = bitAnd(bits, Screen.BIT_MIRROR_X) > 0
    mirrorY = bitAnd(bits, Screen.BIT_MIRROR_Y) > 0

    xTile = tile % 32
    yTile = floor(tile / 32)
    toffs = xTile * 8 + yTile * 8 * sheet.width

    for y in range(0, 7)
        ys = y
        if mirrorY then ys = 7 - y
        if y + yp < 0 or y + yp >= self.height then continue
        for x in range(0, 7)
            if x + xp < 0 or x + xp >= self.width then continue

            xs = x
            if mirrorX then xs = 7 - x
            col = bitAnd(floor(colors / (2 ^ (sheet.pixels[xs + ys * sheet.width + toffs] * 8))), 255)
            // col = (colors >> (sheet.pixels[xs + ys * sheet.width + toffs] * 8)) & 255;

            if col < 255 then
                // self.pixels[(x + xp) + (y + yp) * self.w] = col
                self.setPixel(x + xp, self.height - (y + yp) - 1, Game.COLORS[col])
            end if
        end for
    end for

    self.numTiles += 1
    return self.numTiles - 1
end function

grassColor = 141
col = Color.get(grassColor, grassColor, grassColor + 111, grassColor + 111)
tileGeneratorDisplay.generateTile sheet, 0, col

clear
display(5).mode = displayMode.tile
td = display(5)
td.tileSet = tileGeneratorDisplay.getImage
td.tileSetTileSize = 8  // size of each tile in the image
td.extent = [floor(Game.WIDTH / 8), floor(Game.HEIGHT / 8)]  // columns, rows on screen


// set up the initial tile pattern
td.clear 0  // clear to tile 20 (dark blue circle)
for row in range(0, 9)
	td.setCell 0, row, 6 // tile 6 is a yellow square
	td.setCell 14, row, 6
end for
for col in range(0, 14)
	td.setCell col, 0, 1  // tile 1 is a gray square
	td.setCell col, 9, 1
end for

// main loop
cellIdx = 0
while true
	td.setCell 7, 5, cellIdx
	cellIdx = (cellIdx + 1) % 64
	wait 0.1
end while