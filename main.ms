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

globals.InputHandler = require("InputHandler")

print "micro-hack!"

input = (new InputHandler).make

events.eventLoop.onKeyDown["[8]"] = function; input.up.toggle(true); end function
events.eventLoop.onKeyDown["[2]"] = function; input.down.toggle(true); end function
events.eventLoop.onKeyDown["[4]"] = function; input.left.toggle(true); end function
events.eventLoop.onKeyDown["[6]"] = function; input.right.toggle(true); end function
events.eventLoop.onKeyDown["w"] = function; input.up.toggle(true); end function
events.eventLoop.onKeyDown["s"] = function; input.down.toggle(true); end function
events.eventLoop.onKeyDown["a"] = function; input.left.toggle(true); end function
events.eventLoop.onKeyDown["d"] = function; input.right.toggle(true); end function
events.eventLoop.onKeyDown["up"] = function; input.up.toggle(true); end function
events.eventLoop.onKeyDown["down"] = function; input.down.toggle(true); end function
events.eventLoop.onKeyDown["left"] = function; input.left.toggle(true); end function
events.eventLoop.onKeyDown["right"] = function; input.right.toggle(true); end function

events.eventLoop.onKeyDown["tab"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["left alt"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["right alt"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["enter"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["return"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["x"] = function; input.menu.toggle(true); end function
events.eventLoop.onKeyDown["space"] = function; input.attack.toggle(true); end function
events.eventLoop.onKeyDown["[0]"] = function; input.attack.toggle(true); end function
events.eventLoop.onKeyDown["c"] = function; input.attack.toggle(true); end function

events.eventLoop.onKeyUp["[8]"] = function; input.up.toggle(false); end function
events.eventLoop.onKeyUp["[2]"] = function; input.down.toggle(false); end function
events.eventLoop.onKeyUp["[4]"] = function; input.left.toggle(false); end function
events.eventLoop.onKeyUp["[6]"] = function; input.right.toggle(false); end function
events.eventLoop.onKeyUp["w"] = function; input.up.toggle(false); end function
events.eventLoop.onKeyUp["s"] = function; input.down.toggle(false); end function
events.eventLoop.onKeyUp["a"] = function; input.left.toggle(false); end function
events.eventLoop.onKeyUp["d"] = function; input.right.toggle(false); end function
events.eventLoop.onKeyUp["up"] = function; input.up.toggle(false); end function
events.eventLoop.onKeyUp["down"] = function; input.down.toggle(false); end function
events.eventLoop.onKeyUp["left"] = function; input.left.toggle(false); end function
events.eventLoop.onKeyUp["right"] = function; input.right.toggle(false); end function

events.eventLoop.onKeyUp["tab"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["left alt"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["right alt"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["enter"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["return"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["x"] = function; input.menu.toggle(false); end function
events.eventLoop.onKeyUp["space"] = function; input.attack.toggle(false); end function
events.eventLoop.onKeyUp["[0]"] = function; input.attack.toggle(false); end function
events.eventLoop.onKeyUp["c"] = function; input.attack.toggle(false); end function

tick = function
    globals.tickCount += 1
    input.tick

    if input.up.clicked or input.left.clicked then
        globals.level -= 1
        renderLevel level 
    end if
    if input.down.clicked or input.right.clicked then
        globals.level += 1
        renderLevel level
    end if
    // if input.attack.clicked then print "attack"
    // if input.menu.clicked then print "menu"
end function

events.eventLoop.onUpdate = function
    now = time
    globals.unprocessed += (now - lastTime) / secsPerTick
    globals.lastTime = now

    // print "Unprocessed: " + unprocessed
    while unprocessed >= 1
        globals.ticks += 1
        tick
        globals.unprocessed -= 1
    end while
end function

// @param {int} level
renderLevel = function(level)
    SCALE = 4.5
    setCell = function(x, y, color)
        gfx.fillRect x * SCALE, y * SCALE, SCALE + 1, SCALE + 1, color
    end function
    d = 0

    w = 128
    h = 128

    text.clear
    gfx.clear

    if level == -1 then
        map = LevelGen.createAndValidateSkyMap(w, h)[0]
    else if level == 0 then
        map = LevelGen.createAndValidateTopMap(w, h)[0]
    else
        map = LevelGen.createAndValidateUndergroundMap(w, h, level)[0]
    end if
    // map = LevelGen.createAndValidateUndergroundMap(w, h, (d++ % 3) + 1)[0]
    // map = LevelGen.createAndValidateSkyMap(w, h)[0]
    for y in range(0, h - 1)
        for x in range(0, w - 1)
            i = x + y * w

            if map[i] == Tile.water.id then setCell(x, y, "#000080")
            if map[i] == Tile.grass.id then setCell(x, y, "#208020")
            if map[i] == Tile.rock.id then setCell(x, y, "#a0a0a0")
            if map[i] == Tile.dirt.id then setCell(x, y, "#604040")
            if map[i] == Tile.sand.id then setCell(x, y, "#a0a040")
            if map[i] == Tile.tree.id then setCell(x, y, "#003000")
            if map[i] == Tile.lava.id then setCell(x, y, "#ff2020")
            if map[i] == Tile.cloud.id then setCell(x, y, "#a0a0a0")
            if map[i] == Tile.stairsDown.id then setCell(x, y, "#ffffff")
            if map[i] == Tile.stairsUp.id then setCell(x, y, "#ffffff")
            if map[i] == Tile.cloudCactus.id then setCell(x, y, "#ff00ff")
        end for
    end for

    text.row = 25
    text.column = 0
    print "level=" + level
end function

level = 0

renderLevel level

tickCount = 0

lastTime = time
unprocessed = 0
secsPerTick = 1 / 60
frames = 0
ticks = 0

events.eventLoop.run