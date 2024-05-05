Level = {}
Level.grassColor = 141
Level.dirtColor = 322
Level.sandColor = 550
Level.monsterDensity = 8;

// @param {int} w
// @param {int} h
// @param {int} level
// @param {Level} parentLevel
// @returns {Level}
Level.make = function(w, h, level, parentLevel)
    if level < 0 then
        self.dirtColor = 222
    end if
    self.depth = level
    self.w = w
    self.h = h

    if level == 1 then
        self.dirtColor = 444
    end if
    if level == 0 then
        maps = LevelGen.createAndValidateTopMap(w, h)
    else if level < 0 then
        maps = LevelGen.createAndValidateUndergroundMap(w, h, -level)
        self.monsterDensity = 4
    else
        maps = LevelGen.createAndValidateSkyMap(w, h) // Sky level
        self.monsterDensity = 4
    end if

    self.tiles = maps[0]
    self.data = maps[1]

    if parentLevel != null then
        for y in range(0, self.h - 1)
            for x in range(0, self.w - 1)
                if parentLevel.getTile(x, y) == Tile.stairsDown then
                    self.setTile(x, y, Tile.stairsUp, 0)
                    if level == 0 then
                        self.setTile(x - 1, y, Tile.hardRock, 0)
                        self.setTile(x + 1, y, Tile.hardRock, 0)
                        self.setTile(x, y - 1, Tile.hardRock, 0)
                        self.setTile(x, y + 1, Tile.hardRock, 0)
                        self.setTile(x - 1, y - 1, Tile.hardRock, 0)
                        self.setTile(x - 1, y + 1, Tile.hardRock, 0)
                        self.setTile(x + 1, y - 1, Tile.hardRock, 0)
                        self.setTile(x + 1, y + 1, Tile.hardRock, 0)
                    else
                        self.setTile(x - 1, y, Tile.dirt, 0)
                        self.setTile(x + 1, y, Tile.dirt, 0)
                        self.setTile(x, y - 1, Tile.dirt, 0)
                        self.setTile(x, y + 1, Tile.dirt, 0)
                        self.setTile(x - 1, y - 1, Tile.dirt, 0)
                        self.setTile(x - 1, y + 1, Tile.dirt, 0)
                        self.setTile(x + 1, y - 1, Tile.dirt, 0)
                        self.setTile(x + 1, y + 1, Tile.dirt, 0)
                    end if
                end if
            end for
        end for
    end if

    self.entitiesInTiles = [0] * self.w * self.h
    for i in range(0, self.w * self.h - 1)
        self.entitiesInTiles[i] = []
    end for
    
    if level == 1 then
        aw = (new AirWizard).make
        aw.x = self.w * 8
        aw.y = self.h * 8
        self.add(aw)
    end if

    return self
end function

// @param {Screen} screen
// @param {int} xScroll
// @param {int} yScroll
Level.renderBackground = function(screen, xScroll, yScroll)
    xo = floor(xScroll / 16)
    yo = floor(yScroll / 16)
    w = floor((screen.w + 15) / 16)
    h = floor((screen.h + 15) / 16)
    screen.setOffset(xScroll, yScroll)
    for y in range(yo, h + yo)
        for x in range(xo, w + xo)
            self.getTile(x, y).render(screen, self, x, y)
        end for
    end for
    screen.setOffset(0, 0)
end function

// @param {Screen} screen
// @param {int} xScroll
// @param {int} yScroll
Level.renderSprites = function(screen, xScroll, yScroll)
    xo = floor(xScroll / 16)
    yo = floor(yScroll / 16)
    w = floor((screen.w + 15) / 16)
    h = floor((screen.h + 15) / 16)

    screen.setOffset(xScroll, yScroll)
    for y in range(yo, h + yo)
        for x in range(xo, w + xo)
            if x < 0 or y < 0 or x >= self.w or y >= self.h then continue
            self.rowSprites.addAll(self.entitiesInTiles[x + y * self.w])
        end for
        if self.rowSprites.len > 0 then
            self.sortAndRender(screen, self.rowSprites)
        end if
        self.rowSprites = []
    end for
    screen.setOffset(0, 0)
end function

// @param {Screen} screen
// @param {int} xScroll
// @param {int} yScroll
Level.renderLight = function(screen, xScroll, yScroll)
    xo = floor(xScroll / 16)
    yo = floor(yScroll / 16)
    w = floor((screen.w + 15) / 16)
    h = floor((screen.h + 15) / 16)

    screen.setOffset(xScroll, yScroll)
    r = 4
    for y in range(yo - r, h + yo + r)
        for x in range(xo - r, w + xo + r)
            if x < 0 or y < 0 or x >= self.w or y >= self.h then continue
            entities = self.entitiesInTiles[x + y * self.w]
            for i in range(0, entities.len - 1)
                e = entities[i]
                lr = e.getLightRadius
                if lr > 0 then screen.renderLight(e.x - 1, e.y - 4, lr * 8)
            end for
            lr = getTile(x, y).getLightRadius(self, x, y)
            if lr > 0 then screen.renderLight(x * 16 + 8, y * 16 + 8, lr * 8)
        end for
    end for
    screen.setOffset(0, 0)
end function

// @param {Screen} screen
// @param {Entity[]} list
Level.sortAndRender = function(screen, list)
    list.sort "y"
    for i in range(0, list.len - 1)
        list[i].render(screen)
    end for
end function

// @param {int} x
// @param {int} y
// @returns {Tile}
Level.getTile = function(x, y)
    if x < 0 or y < 0 or x >= self.w or y >= h then return Tile.rock
    return Tile.tiles[self.tiles[x + y * self.w]]
end function

// @param {int} x
// @param {int} y
// @param {Tile} tile
// @param {int} dataVal
Level.setTile = function(x, y, t, dataVal)
    if x < 0 or y < 0 or x >= self.w or y >= self.h then return
    self.tiles[x + y * self.w] = t.id
    self.data[x + y * self.w] = dataVal
end function

// @param {int} x
// @param {int} y
// @returns {int}
Level.getData = function(x, y)
    if x < 0 or y < 0 or x >= self.w or y >= self.h then return 0
    return bitAnd(self.data[x + y * self.w], 255)
end function

// @param {int} x
// @param {int} y
// @returns {int}
Level.setData = function(x, y, val)
    if x < 0 or y < 0 or x >= self.w or y >= self.h then return
    self.data[x + y * self.w] = val
end function

// @param {Entity} entity
Level.add = function(entity)
    if entity isa Player then
        player = entity
    end if
    entity.removed = false
    self.entities.push(entity)
    entity.init(self)

    self.insertEntity(floor(entity.x / 16), floor(entity.y / 16), entity)
end function

// @param {Entity} e
Level.remove = function(e)
    self.entities.remove(e)
    xto = floor(e.x / 16)
    yto = floor(e.y / 16)
    self.removeEntity(xto, yto, e)
end function

// @param {int} x
// @param {int} y
// @param {Entity} e
Level.insertEntity = function(x, y, e)
    if x < 0 or y < 0 or x >= self.w or y >= h then return
    self.entitiesInTiles[x + y * self.w].push(e)
end function

// @param {int} x
// @param {int} y
// @param {Entity} e
Level.removeEntity = function(x, y, e)
    if x < 0 or y < 0 or x >= self.w or y >= self.h then return
    offset = x + y * self.w
    for n in range(0, self.entitiesInTiles[offset].len - 1)
        if refEquals(e, self.entitiesInTiles[offset][n]) then
            self.entitiesInTiles[offset].remove(n)
        end if
    end for
end function

// @param {int} count
Level.trySpawn = function(count)
    for i in range(0, count - 1)
        minLevel = 1
        maxLevel = 1
        if self.depth < 0 then
            maxLevel = (-depth) + 1
        end if
        if self.depth > 0 then
            maxLevel = 4
            minLevel = maxLevel
        end if

        lvl = Random.nextInt(maxLevel - minLevel + 1) + minLevel
        if Random.nextInt(2) == 0 then
            mob = (new Slime).make(lvl)
        else
            mob = (new Zombie).make(lvl)
        end if

        if mob.findStartPos(self) then
            self.add(mob)
        end if
    end for
end function

Level.tick = function
    self.trySpawn(1)

    for i in range(0, w * h / 50 - 1)
        xt = Random.nextInt(w)
        yt = Random.nextInt(w)
        self.getTile(xt, yt).tick(self, xt, yt)
    end for
    for i in range(self.entities.len - 1)
        e = self.entities[i]
        xto = floor(e.x / 16)
        yto = floor(e.y / 16)

        e.tick

        if e.removed then
            self.entities.remove(i)
            i -= 1
            self.removeEntity(xto, yto, e)
        else
            xt = floor(e.x / 16)
            yt = floor(e.y / 16)

            if xto != xt or yto != yt then
                self.removeEntity(xto, yto, e)
                self.insertEntity(xt, yt, e)
            end if
        end if
    end for
end function

// @param {int} x0
// @param {int} y0
// @param {int} x1
// @param {int} y1
// @returns {Entity[]}
Level.getEntities = function(x0, y0, x1, y1)
    result = []
    xt0 = floor(x0 / 16) - 1
    yt0 = floor(y0 / 16) - 1
    xt1 = floor(x1 / 16) + 1
    yt1 = floor(y1 / 16) + 1
    for y in range(yt0, yt1)
        for x in range(xt0, xt1)
            if x < 0 or y < 0 or x >= self.w or y >= self.h then continue
            entities = self.entitiesInTiles[x + y * self.w]
            for i in range(entities.len - 1)
                e = entities[i]
                if e.intersects(x0, y0, x1, y1) then result.push(e)
            end for
        end for
    end for
    return result
end function

return Level
