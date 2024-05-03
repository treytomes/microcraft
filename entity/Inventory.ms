Inventory = {}

// @returns {Inventory}
Inventory.make = function()
    // @type {Item[]}
    self.items = []
    return self
end function

// @param {int | Item} slot
// @param {Item | null} item
Inventory.add = function(slot, item = null)
    if item != null then
        if item isa ResourceItem then
            toTake = item
            has = self.findResource(toTake.resource)
            if has == null then
                self.items.insert(slot, toTake)
            else
                has.count += toTake.count
            end if
        else
            self.items.add(slot, item)
        end if
    else
        item = slot
        self.add(self.items.len, item)
    end if
end function

// @param {Resource} resource
// @returns {ResourceItem}
Inventory.findResource = function(resource)
    for i in range(0, self.items.len - 1)
        if items[i] isa ResourceItem then
            has = items[i]
            if refEquals(has.resource, resource) then return has
        end if
    end for
    return null
end function

// @param {Resource} r
// @param {int} count
// @returns {boolean}
Inventory.hasResources = function(r, count)
    ri = self.findResource(r)
    if ri == null then return false
    return ri.count >= count
end function

// @param {Resource} r
// @param {int} count
// @returns {boolean}
Inventory.removeResource = function(r, count)
    ri = self.findResource(r)
    if ri == null then return false
    if ri.count < count then return false
    ri.count -= count
    if ri.count <= 0 then self.items.remove(ri)
    return true
end function

// @param {Item} item
// @returns {int}
Inventory.count = function(item)
    if item isa ResourceItem then
        ri = self.findResource(item.resource);
        if ri != null then return ri.count
    else
        count = 0
        for i in range(0, items.len - 1)
            if items[i].matches(item) then count += 1
        end for
        return count
    end if
    return 0
end function

return Inventory
