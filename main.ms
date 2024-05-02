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

// screen
globals.ListItem = require("ListItem")

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

// item
globals.Item = require("Item")
globals.FurnitureItem = require("FurnitureItem")
globals.PowerGloveItem = require("PowerGloveItem")
globals.ResourceItem = require("ResourceItem")
globals.ToolItem = require("ToolItem")
globals.ToolType = require("ToolType")

// item/source
// TODO: I'm expecting a circular dependency here.  Might need a factory initializer for recipes and resouces.
globals.Resource = require("Resource")
globals.FoodResource = require("FoodResource")
globals.PlantableResource = require("PlantableResource")

// gfx
globals.Color = require("Color")
globals.Font = require("Font")
globals.Screen = require("Screen")
globals.Sprite = require("Sprite")
globals.SpriteSheet = require("SpriteSheet")

// sound
globals.Sounds = require("Sounds") // Had to rename this one to avoid naming conflicts.

globals.InputHandler = require("InputHandler")

print "micro-hack!"


input = (new InputHandler).init

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

    if input.up.clicked then print "up"
    if input.down.clicked then print "down"
    if input.left.clicked then print "left"
    if input.right.clicked then print "right"
    if input.attack.clicked then print "attack"
    if input.menu.clicked then print "menu"
end function

events.eventLoop.onUpdate = function
    now = time
    globals.unprocessed += (now - lastTime) / secsPerTick
    lastTime = now

    // print "Unprocessed: " + unprocessed
    while unprocessed >= 1
        globals.ticks += 1
        tick
        globals.unprocessed -= 1
    end while
end function

tickCount = 0

lastTime = time
unprocessed = 0
secsPerTick = 1 / 60
frames = 0
ticks = 0

events.eventLoop.run