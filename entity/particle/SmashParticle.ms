// TODO: Shouldn't this inherit from Particle?
SmashParticle = new Particle

// @param {int} x
// @param {int} y
// @returns {SmashParticle}
SmashParticle.make = function(x, y)
    super.make
    self.time = 0
    self.x = x
    self.y = y
    Sounds.monsterHurt.play
    return self
end function

SmashParticle.tick = function()
    self.time += 1
    if self.time > 10 then
        self.remove
    end if
end function

// @param {Screen} screen
SmashParticle.render = function(screen)
    col = Color.get(-1, 555, 555, 555)
    screen.render(self.x - 8, self.y - 8, 5 + 12 * 32, col, 2)
    screen.render(self.x - 0, self.y - 8, 5 + 12 * 32, col, 3)
    screen.render(self.x - 8, self.y - 0, 5 + 12 * 32, col, 0)
    screen.render(self.x - 0, self.y - 0, 5 + 12 * 32, col, 1)
end function

return SmashParticle
