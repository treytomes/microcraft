// TODO: Shouldn't this inherit from Particle?
TextParticle = new Entity

// @param {string} msg
// @param {int} x
// @param {int} y
// @param {int} col
// @returns {TextParticle}
TextParticle = function(msg, x, y, col)
    self.time = 0
    self.msg = msg
    self.x = x
    self.y = y
    self.col = col
    self.xx = x
    self.yy = y
    self.zz = 2
    self.xa = Random.nextGaussian * 0.3
    self.ya = Random.nextGaussian * 0.2
    self.za = Random.nextFloat * 0.7 + 2
    return self
end function

TextParticle.tick = function()
    self.time += 1
    if self.time > 60 then
        self.remove
    end if
    self.xx += self.xa
    self.yy += self.ya
    self.zz += self.za
    if self.zz < 0 then
        self.zz = 0
        self.za *= -0.5
        self.xa *= 0.6
        self.ya *= 0.6
    end if
    self.za -= 0.15
    self.x = floor(self.xx)
    self.y = floor(self.yy)
end function

// @param {Screen} screen
TextParticle.render = function(screen)
    Font.draw(self.msg, screen, self.x - self.msg.len * 4 + 1, self.y - floor(self.zz) + 1, Color.get(-1, 0, 0, 0))
    Font.draw(self.msg, screen, self.x - self.msg.len * 4, self.y - floor(self.zz), self.col)
end function

return TextParticle
