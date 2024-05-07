Spark = new Entity

// @param {AirWizard} owner
// @param {double} xa
// @param {double} ya
// @returns Spark
Spark.make = function(owner, xa, ya)
    super.make
    
    self.time = 0
    self.owner = owner
    self.x = owner.x
    self.y = owner.y
    self.xx = owner.x
    self.yy = owner.y
    self.xr = 0
    self.yr = 0

    self.xa = xa
    self.ya = ya

    self.lifeTime = 60 * 10 + Random.nextInt(30)

    return self
end function

Spark.tick = function()
    self.time += 1
    if self.time >= self.lifeTime then
        self.remove
        return
    end if
    self.xx += self.xa
    self.yy += self.ya
    self.x = floor(xx)
    self.y = floor(yy)
    toHit = self.level.getEntities(self.x, self.y, self.x, self.y);
    for i in range(0, toHit.len - 1)
        e = toHit[i]
        if e isa Mob and not (e isa AirWizard) then
            e.hurt(self.owner, 1, bitXor(e.dir, 1))
        end if
    end for
end function

// @param {Mob} mob
// @returns {boolean}
Spark.isBlockableBy = function(mob)
    return false
end function

// @param {Screen} screen
Spark.render = function(screen)
    if self.time >= self.lifeTime - 6 * 20 then
        if self.time / 6 % 2 == 0 then return
    end if

    xt = 8
    yt = 13

    screen.render(self.x - 4, self.y - 4 - 2, xt + yt * 32, Color.get(-1, 555, 555, 555), Random.nextInt(4))
    screen.render(self.x - 4, self.y - 4 + 2, xt + yt * 32, Color.get(-1, 000, 000, 000), Random.nextInt(4))
end function

return Spark
