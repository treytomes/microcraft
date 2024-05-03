Player = new Mob

// @param {Game} game
// @param {InputHandler} input
// @returns {Player}
Player.make = function(game, input)
    self.attackTime = 0
    self.attackDir = 0

    self.inventory = (new Inventory).make()
    self.attackItem = null
    self.activeItem = null
    self.staminaRecharge = 0
    self.staminaRechargeDelay = 0
    self.score = 0
    self.maxStamina = 10
    self.onStairDelay = 0
    self.invulnerableTime = 0

    self.game = game
    self.input = input
    self.x = 24
    self.y = 24
    self.stamina = maxStamina

    inventory.push((new FurnitureItem).make((new Workbench).make))
    inventory.push((new PowerGloveItem).make)

    return self
end function

Player.tick = function()
    super.tick

    if self.invulnerableTime > 0 then self.invulnerableTime -= 1
    onTile = self.level.getTile(floor(x / 16), floor(y / 16))
    if refEquals(onTile, Tile.stairsDown) or refEquals(onTile, Tile.stairsUp) then
        if self.onStairDelay == 0 then
            if refEquals(onTile, Tile.stairsUp) then
                self.changeLevel(1)
            else
                self.changeLevel(-1)
            end if
            self.onStairDelay = 10
            return;
        end if
        self.onStairDelay = 10
    else
        if self.onStairDelay > 0 then self.onStairDelay -= 1
    end if

    if self.stamina <= 0 and self.staminaRechargeDelay == 0 and self.staminaRecharge == 0 then
        self.staminaRechargeDelay = 40
    end if

    if self.staminaRechargeDelay > 0 then
        self.staminaRechargeDelay -= 1
    end if

    if self.staminaRechargeDelay == 0 then
        self.staminaRecharge += 1
        if self.isSwimming then
            self.staminaRecharge = 0
        end if
        while self.staminaRecharge > 10
            self.staminaRecharge -= 10
            if self.stamina < self.maxStamina then stamina += 1
        end while
    end if

    xa = 0
    ya = 0
    if self.input.up.down then ya -= 1
    if self.input.down.down then ya += 1
    if self.input.left.down then xa -= 1
    if self.input.right.down then xa += 1
    if self.isSwimming and self.tickTime % 60 == 0 then
        if self.stamina > 0 then
            self.stamina -= 1
        else
            self.hurt(self, 1, bitXor(self.dir, 1))
        end if
    end if

    if self.staminaRechargeDelay % 2 == 0 then
        self.move(xa, ya)
    end if

    if self.input.attack.clicked then
        if self.stamina == 0 then

        else
            self.stamina -= 1
            self.staminaRecharge = 0
            self.attack
        end if
    end if
    if self.input.menu.clicked then
        if not self.use then
            self.game.setMenu((new InventoryMenu).make(self))
        end if
    end if
    if self.attackTime > 0 then self.attackTime -= 1
end function

// @returns boolean
Player.use = function
    yo = -2
    if self.dir == 0 and self.use(self.x - 8, self.y + 4 + yo, self.x + 8, self.y + 12 + yo) then return true
    if self.dir == 1 and self.use(self.x - 8, self.y - 12 + yo, self.x + 8, self.y - 4 + yo) then return true
    if self.dir == 3 and self.use(self.x + 4, self.y - 8 + yo, self.x + 12, self.y + 8 + yo) then return true
    if self.dir == 2 and self.use(self.x - 12, self.y - 8 + yo, self.x - 4, self.y + 8 + yo) then return true

    xt = floor(self.x / 16)
    yt = floor((self.y + yo) / 16)
    r = 12
    if self.attackDir == 0 then yt = floor((self.y + r + yo) / 16)
    if self.attackDir == 1 then yt = floor((self.y - r + yo) / 16)
    if self.attackDir == 2 then xt = floor((self.x - r) / 16)
    if self.attackDir == 3 then xt = floor((self.x + r) / 16)

    if xt >= 0 and yt >= 0 and xt < self.level.w and yt < self.level.h then
        if self.level.getTile(xt, yt).use(self.level, xt, yt, self, self.attackDir) then return true
    end if

    return false
end function

Player.attack = function
    self.walkDist += 8
    self.attackDir = self.dir
    self.attackItem = self.activeItem
    done = false

    if self.activeItem != null then
        self.attackTime = 10
        yo = -2
        range = 12
        if self.dir == 0 and self.interact(self.x - 8, self.y + 4 + yo, self.x + 8, self.y + range + yo) then done = true
        if self.dir == 1 and self.interact(self.x - 8, self.y - range + yo, self.x + 8, self.y - 4 + yo) then done = true
        if self.dir == 3 and self.interact(self.x + 4, self.y - 8 + yo, self.x + range, self.y + 8 + yo) then done = true
        if self.dir == 2 and self.interact(self.x - range, self.y - 8 + yo, self.x - 4, self.y + 8 + yo) then done = true
        if done then return

        xt = floor(self.x / 16)
        yt = floor((self.y + yo) / 16)
        r = 12
        if self.attackDir == 0 then yt = floor((self.y + r + yo) / 16)
        if self.attackDir == 1 then yt = floor((self.y - r + yo) / 16)
        if self.attackDir == 2 then xt = floor((self.x - r) / 16)
        if self.attackDir == 3 then xt = floor((self.x + r) / 16)

        if xt >= 0 and yt >= 0 and xt < self.level.w and yt < self.level.h then
            if self.activeItem.interactOn(self.level.getTile(xt, yt), self.level, xt, yt, self, self.attackDir) then
                done = true
            else
                if self.level.getTile(xt, yt).interact(self.level, xt, yt, self, self.activeItem, self.attackDir) then
                    done = true
                end if
            end if
            if self.activeItem.isDepleted() then
                self.activeItem = null
            end if
        end if
    end if

    if done then return

    if self.activeItem == null or self.activeItem.canAttack then
        self.attackTime = 5
        yo = -2
        range = 20
        if self.dir == 0 then self.hurt(self.x - 8, self.y + 4 + yo, self.x + 8, self.y + range + yo)
        if self.dir == 1 then self.hurt(self.x - 8, self.y - range + yo, self.x + 8, self.y - 4 + yo)
        if self.dir == 3 then self.hurt(self.x + 4, self.y - 8 + yo, self.x + range, self.y + 8 + yo)
        if self.dir == 2 then self.hurt(self.x - range, self.y - 8 + yo, self.x - 4, self.y + 8 + yo)

        xt = floor(self.x / 16)
        yt = floor((self.y + yo) / 16)
        r = 12
        if self.attackDir == 0 then yt = floor((self.y + r + yo) / 16)
        if self.attackDir == 1 then yt = floor((self.y - r + yo) / 16)
        if self.attackDir == 2 then xt = floor((self.x - r) / 16)
        if self.attackDir == 3 then xt = floor((self.x + r) / 16)

        if xt >= 0 and yt >= 0 and xt < self.level.w and yt < self.level.h then
            self.level.getTile(xt, yt).hurt(self.level, xt, yt, self, Random.nextInt(3) + 1, self.attackDir)
        end if
    end if
end function

// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
// @returns boolean
Player.use = function(x0, y0, x1, y1)
    entities = self.level.getEntities(x0, y0, x1, y1)
    for i in range(0, entities.len - 1)
        e = entities[i]
        if not refEquals(e, self) then
            if e.use(self, self.attackDir) then
                return true
            end if
        end if
    end for
    return false
end function

// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
// @returns boolean
Player.interact = function(x0, y0, x1, y1)
    entities = self.level.getEntities(x0, y0, x1, y1)
    for i in range(0, entities.len - 1)
        e = entities[i]
        if not refEquals(e, self) then
            if e.interact(self, self.activeItem, self.attackDir) then
                return true
            end if
        end if
    end for
    return false
end function

// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
Player.hurt = function(x0, y0, x1, y1)
    entities = self.level.getEntities(x0, y0, x1, y1)
    for i in range(entities.len - 1)
        e = entities[i]
        if not refEquals(e, self) then e.hurt(self, self.getAttackDamage(e), self.attackDir)
    end for
end function

// @param {Entity} e
// @returns {int}
Player.getAttackDamage = function(e)
    dmg = Random.nextInt(3) + 1
    if self.attackItem != null then
        dmg += self.attackItem.getAttackDamageBonus(e)
    end if
    return dmg
end function

// @param {Screen} screen
Player.render = function(screen)
    xt = 0
    yt = 14

    flip1 = bitAnd(floor(self.walkDist / 8), 1)
    flip2 = bitAnd(floor(self.walkDist / 8), 1)

    if self.dir == 1 then
        xt += 2
    end if
    if self.dir > 1 then
        flip1 = 0
        flip2 = bitAnd(floor(self.walkDist / 16), 1)
        if self.dir == 2 then
            flip1 = 1
        end if
        xt += 4 + bitAnd(floor(walkDist / 8), 1) * 2
    end if

    xo = self.x - 8
    yo = self.y - 11
    if self.isSwimming then
        yo += 4
        waterColor = Color.get(-1, -1, 115, 335)
        if floor(self.tickTime / 8) % 2 == 0 then
            waterColor = Color.get(-1, 335, 5, 115)
        end if
        screen.render(xo + 0, yo + 3, 5 + 13 * 32, waterColor, 0)
        screen.render(xo + 8, yo + 3, 5 + 13 * 32, waterColor, 1)
    end if

    if self.attackTime > 0 and self.attackDir == 1 then
        screen.render(xo + 0, yo - 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 0)
        screen.render(xo + 8, yo - 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 1)
        if self.attackItem != null then
            self.attackItem.renderIcon(screen, xo + 4, yo - 4)
        end if
    end if
    col = Color.get(-1, 100, 220, 532)
    if self.hurtTime > 0 then
        col = Color.get(-1, 555, 555, 555)
    end if

    if self.activeItem isa FurnitureItem then
        yt += 2
    end if
    screen.render(xo + 8 * flip1, yo + 0, xt + yt * 32, col, flip1)
    screen.render(xo + 8 - 8 * flip1, yo + 0, xt + 1 + yt * 32, col, flip1)
    if not self.isSwimming then
        screen.render(xo + 8 * flip2, yo + 8, xt + (yt + 1) * 32, col, flip2)
        screen.render(xo + 8 - 8 * flip2, yo + 8, xt + 1 + (yt + 1) * 32, col, flip2)
    end if

    if self.attackTime > 0 and self.attackDir == 2 then
        screen.render(xo - 4, yo, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 1)
        screen.render(xo - 4, yo + 8, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 3)
        if self.attackItem != null then
            self.attackItem.renderIcon(screen, xo - 4, yo + 4)
        end if
    end if
    if self.attackTime > 0 and self.attackDir == 3 then
        screen.render(xo + 8 + 4, yo, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 0)
        screen.render(xo + 8 + 4, yo + 8, 7 + 13 * 32, Color.get(-1, 555, 555, 555), 2)
        if self.attackItem != null then
            self.attackItem.renderIcon(screen, xo + 8 + 4, yo + 4)
        end if
    end if
    if self.attackTime > 0 and self.attackDir == 0 then
        screen.render(xo + 0, yo + 8 + 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 2)
        screen.render(xo + 8, yo + 8 + 4, 6 + 13 * 32, Color.get(-1, 555, 555, 555), 3)
        if self.attackItem != null then
            self.attackItem.renderIcon(screen, xo + 4, yo + 8 + 4)
        end if
    end if

    if self.activeItem isa FurnitureItem then
        furniture = activeItem.furniture
        furniture.x = self.x
        furniture.y = yo
        furniture.render(screen)
    end if
end function

// @param {ItemEntity} itemEntity
Player.touchItem = function(itemEntity)
    itemEntity.take(self)
    self.inventory.add(itemEntity.item)
end function

// @returns {boolean}
Player.canSwim = function()
    return true
end function

// @param {Level} level
// @returns {boolean}
Player.findStartPos = function(level)
    while true
        x = Random.nextInt(level.w)
        y = Random.nextInt(level.h)
        if refEquals(level.getTile(x, y), Tile.grass) then
            self.x = x * 16 + 8
            self.y = y * 16 + 8
            return true;
        end if
    end while
end function

// @param {int} cost
// @returns {boolean}
Player.payStamina = function(cost)
    if cost > self.stamina then return false
    self.stamina -= cost
    return true
end function

// @param {int} dir
Player.changeLevel = function(dir)
    self.game.scheduleLevelChange(dir)
end function

// @returns {int}
Player.getLightRadius = function()
    r = 2
    if self.activeItem != null then
        if self.activeItem isa FurnitureItem then
            rr = self.activeItem.furniture.getLightRadius
            if rr > r then r = rr
        end if
    end if
    return r
end function

Player.die = function()
    super.die
    Sound.playerDeath.play
end function

// @param {Entity} entity
Player.touchedBy = function(entity)
    if not (entity isa Player) then
        entity.touchedBy(self)
    end if
end function

// @param {int} damage
// @param {int} attackDir
Player.doHurt = function(damage, attackDir)
    if self.hurtTime > 0 or self.invulnerableTime > 0 then return

    Sound.playerHurt.play()
    self.level.add((new TextParticle).make("" + damage, self.x, self.y, Color.get(-1, 504, 504, 504)))
    self.health -= damage
    if self.attackDir == 0 then self.yKnockback =  6
    if self.attackDir == 1 then self.yKnockback = -6
    if self.attackDir == 2 then self.xKnockback = -6
    if self.attackDir == 3 then self.xKnockback =  6
    self.hurtTime = 10
    self.invulnerableTime = 30
end function

Player.gameWon = function()
    self.level.player.invulnerableTime = 60 * 5
    self.game.won
end function

return Player
