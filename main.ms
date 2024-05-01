import "importUtil"
import "listUtil"

import "coreUtil"

// Note how system-defined symbols can be extended.
env.addImportPath = function(path)
    // `self` == `env`
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./crafting"
env.addImportPath "./entity"
env.addImportPath "./gfx"
env.addImportPath "./item"
env.addImportPath "./item/resource"
env.addImportPath "./level"
env.addImportPath "./level/levelgen"
env.addImportPath "./level/tile"
env.addImportPath "./screen"
env.addImportPath "./sound"

globals.Color = require("Color")
globals.Font = require("Font")
globals.Screen = require("Screen")
globals.Sprite = require("Sprite")
globals.SpriteSheet = require("SpriteSheet")

print "micro-hack!"
