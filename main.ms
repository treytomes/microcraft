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

globals.DEBUG = true

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

events.eventLoop.onKeyDown["[8]"] = function; game.input.up.toggle(true); end function
events.eventLoop.onKeyDown["[2]"] = function; game.input.down.toggle(true); end function
events.eventLoop.onKeyDown["[4]"] = function; game.input.left.toggle(true); end function
events.eventLoop.onKeyDown["[6]"] = function; game.input.right.toggle(true); end function
events.eventLoop.onKeyDown["w"] = function; game.input.up.toggle(true); end function
events.eventLoop.onKeyDown["s"] = function; game.input.down.toggle(true); end function
events.eventLoop.onKeyDown["a"] = function; game.input.left.toggle(true); end function
events.eventLoop.onKeyDown["d"] = function; game.input.right.toggle(true); end function
events.eventLoop.onKeyDown["up"] = function; game.input.up.toggle(true); end function
events.eventLoop.onKeyDown["down"] = function; game.input.down.toggle(true); end function
events.eventLoop.onKeyDown["left"] = function; game.input.left.toggle(true); end function
events.eventLoop.onKeyDown["right"] = function; game.input.right.toggle(true); end function

events.eventLoop.onKeyDown["tab"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["left alt"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["right alt"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["enter"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["return"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["x"] = function; game.input.menu.toggle(true); end function
events.eventLoop.onKeyDown["space"] = function; game.input.attack.toggle(true); end function
events.eventLoop.onKeyDown["[0]"] = function; game.input.attack.toggle(true); end function
events.eventLoop.onKeyDown["c"] = function; game.input.attack.toggle(true); end function

events.eventLoop.onKeyUp["[8]"] = function; game.input.up.toggle(false); end function
events.eventLoop.onKeyUp["[2]"] = function; game.input.down.toggle(false); end function
events.eventLoop.onKeyUp["[4]"] = function; game.input.left.toggle(false); end function
events.eventLoop.onKeyUp["[6]"] = function; game.input.right.toggle(false); end function
events.eventLoop.onKeyUp["w"] = function; game.input.up.toggle(false); end function
events.eventLoop.onKeyUp["s"] = function; game.input.down.toggle(false); end function
events.eventLoop.onKeyUp["a"] = function; game.input.left.toggle(false); end function
events.eventLoop.onKeyUp["d"] = function; game.input.right.toggle(false); end function
events.eventLoop.onKeyUp["up"] = function; game.input.up.toggle(false); end function
events.eventLoop.onKeyUp["down"] = function; game.input.down.toggle(false); end function
events.eventLoop.onKeyUp["left"] = function; game.input.left.toggle(false); end function
events.eventLoop.onKeyUp["right"] = function; game.input.right.toggle(false); end function

events.eventLoop.onKeyUp["tab"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["left alt"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["right alt"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["enter"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["return"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["x"] = function; game.input.menu.toggle(false); end function
events.eventLoop.onKeyUp["space"] = function; game.input.attack.toggle(false); end function
events.eventLoop.onKeyUp["[0]"] = function; game.input.attack.toggle(false); end function
events.eventLoop.onKeyUp["c"] = function; game.input.attack.toggle(false); end function

// tick = function
//     globals.tickCount += 1
//     input.tick

//     if input.up.clicked or input.left.clicked then
//         globals.level -= 1
//         renderLevel level 
//     end if
//     if input.down.clicked or input.right.clicked then
//         globals.level += 1
//         renderLevel level
//     end if
//     // if input.attack.clicked then print "attack"
//     // if input.menu.clicked then print "menu"
// end function

events.eventLoop.onUpdate = function
    now = time
    globals.unprocessed += (now - lastTime) / secsPerTick
    globals.lastTime = now

    // TODO: This is important, but we just can't keep up with unprocessed frames right now.
    // while unprocessed >= 1
    //     globals.ticks += 1
    //     print "Unprocessed: " + unprocessed
    //     game.tick
    //     globals.unprocessed -= 1
    // end while
    globals.ticks += 1
    game.tick

    // TODO: Yield here?

    globals.frames += 1
    game.render

    // TODO: I don't think we need this right now.
    // if time - lastTimer1 > 1 then
    //     globals.lastTimer1 += 1
    //     print ticks + " ticks, " + frames + " fps"
    //     globals.frames = 0
    //     globals.ticks = 0
    // end if
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

// print "micro-hack!"

// input = (new InputHandler).make

// level = 0
// renderLevel level

// tickCount = 0

game = Game.make
game.start
game.init

lastTime = time
lastTimer1 = time
unprocessed = 0
secsPerTick = 1 / 60
frames = 0
ticks = 0

events.eventLoop.run