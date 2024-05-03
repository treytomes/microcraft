ResourceRecipe = new Recipe

// @param {Resource} resource
// @returns {ResourceRecipe}
ResourceRecipe.make = function(resource)
    super.make((new ResourceItem).make(resource, 1))
    self.resource = resource
end function

// @param {Player} player
ResourceRecipe.craft = function(player)
    player.inventory.insert(0, (new ResourceItem).make(resource, 1))
end function

return ResourceRecipe
