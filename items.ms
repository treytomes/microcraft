Tile.grass = (new GrassTile).make(0)
Tile.rock = (new RockTile).make(1)
Tile.water = (new WaterTile).make(2)
Tile.flower = (new FlowerTile).make(3)
Tile.tree = (new TreeTile).make(4)
Tile.dirt = (new DirtTile).make(5)
Tile.sand = (new SandTile).make(6)
Tile.cactus = (new CactusTile).make(7)
Tile.hole = (new HoleTile).make(8)
Tile.treeSapling = (new SaplingTile).make(9, Tile.grass, Tile.tree)
Tile.cactusSapling = (new SaplingTile).make(10, Tile.sand, Tile.cactus)
Tile.farmland = (new FarmTile).make(11)
Tile.wheat = (new WheatTile).make(12)
Tile.lava = (new LavaTile).make(13)
Tile.stairsDown = (new StairsTile).make(14, false)
Tile.stairsUp = (new StairsTile).make(15, true)
Tile.infiniteFall = (new InfiniteFallTile).make(16)
Tile.cloud = (new CloudTile).make(17)
Tile.hardRock = (new HardRockTile).make(18)

// TODO: I don't like how the resource and tile definitions are mixed.
// 3 tiles depend on resource definitions, and a pile of resource definitions depend on tiles.

Resource.ironOre = (new Resource).make("I.ORE", 10 + 4 * 32, Color.get(-1, 100, 322, 544))
Tile.ironOre = (new OreTile).make(19, Resource.ironOre)

Resource.goldOre = (new Resource).make("G.ORE", 10 + 4 * 32, Color.get(-1, 110, 440, 553))
Tile.goldOre = (new OreTile).make(20, Resource.goldOre)

Resource.gem = (new Resource).make("gem", 13 + 4 * 32, Color.get(-1, 101, 404, 545))
Tile.gemOre = (new OreTile).make(21, Resource.gem)

Tile.cloudCactus = (new CloudCactusTile).make(22)

Resource.wood = (new Resource).make("Wood", 1 + 4 * 32, Color.get(-1, 200, 531, 430))
Resource.stone = (new Resource).make("Stone", 2 + 4 * 32, Color.get(-1, 111, 333, 555))
Resource.flower = (new PlantableResource).make("Flower", 0 + 4 * 32, Color.get(-1, 10, 444, 330), Tile.flower, [ Tile.grass ])
Resource.acorn = (new PlantableResource).make("Acorn", 3 + 4 * 32, Color.get(-1, 100, 531, 320), Tile.treeSapling, [ Tile.grass ])
Resource.dirt = (new PlantableResource).make("Dirt", 2 + 4 * 32, Color.get(-1, 100, 322, 432), Tile.dirt, [ Tile.hole, Tile.water, Tile.lava ])
Resource.sand = (new PlantableResource).make("Sand", 2 + 4 * 32, Color.get(-1, 110, 440, 550), Tile.sand, [ Tile.grass, Tile.dirt ])
Resource.cactusFlower = (new PlantableResource).make("Cactus", 4 + 4 * 32, Color.get(-1, 10, 40, 50), Tile.cactusSapling, [ Tile.sand ])
Resource.seeds = (new PlantableResource).make("Seeds", 5 + 4 * 32, Color.get(-1, 10, 40, 50), Tile.wheat, [ Tile.farmland ])
Resource.wheat = (new Resource).make("Wheat", 6 + 4 * 32, Color.get(-1, 110, 330, 550))
Resource.bread = (new FoodResource).make("Bread", 8 + 4 * 32, Color.get(-1, 110, 330, 550), 2, 5)
Resource.apple = (new FoodResource).make("Apple", 9 + 4 * 32, Color.get(-1, 100, 300, 500), 1, 5)

Resource.coal = (new Resource).make("COAL", 10 + 4 * 32, Color.get(-1, 000, 111, 111))
Resource.ironIngot = (new Resource).make("IRON", 11 + 4 * 32, Color.get(-1, 100, 322, 544))
Resource.goldIngot = (new Resource).make("GOLD", 11 + 4 * 32, Color.get(-1, 110, 330, 553))

Resource.slime = (new Resource).make("SLIME", 10 + 4 * 32, Color.get(-1, 10, 30, 50))
Resource.glass = (new Resource).make("glass", 12 + 4 * 32, Color.get(-1, 555, 555, 555))
Resource.cloth = (new Resource).make("cloth", 1 + 4 * 32, Color.get(-1, 25, 252, 141))
Resource.cloud = (new PlantableResource).make("cloud", 2 + 4 * 32, Color.get(-1, 222, 555, 444), Tile.cloud, Tile.infiniteFall)
