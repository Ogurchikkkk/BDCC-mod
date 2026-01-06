extends ItemBase
class_name AnalBeads

var depth:int = 1
var length = 0
var firstsize:float = 1
var numbered:bool = false
var widening:bool = false
var isin:bool = false

func _init():
	id = "AnalBeads"
	depth = 1
	length = RNG.randi_range(3,8)
	firstsize = 1 #?
	numbered = false
	widening = false
	isin = true

func getVisibleName():
	return "Anal Beads"
	
func getDescription():
	GlobalRegistry.itemsRefs[id].length = "3 - 8"
	if widening:
		return "Strig with beads for anal play. Each bead is bigger than the last. "+str(length)+" beads long"
	return "Strig with beads for anal play. "+str(length)+" beads long"

func getPrice():
	return 1

func getSellPrice():
	return 1

func canSell():
	return true
	
func getTags():
	return [
		ItemTag.SoldByGeneralVendomat,
		ItemTag.CanBeForcedByGuards, 
		ItemTag.CanBeForcedInStocks
		]

func getClothingSlot():
	return InventorySlot.Anal

func getRequiredBodypart():
	return BodypartSlot.Anus

func getBuffs():
	var buffs = [
			buff(Buff.AmbientLustBuff, [10]),
			buff(Buff.MinLoosenessAnusBuff, [2.0]),
			buff(Buff.SensitivityGainBuff, [25.0])
		]
	if isin: 
		buffs.append(buff(Buff.BlocksAnusLeakingBuff))
		buffs.append(buff(Buff.ChastityAnusBuff))
	if widening: buffs[1] = buff(Buff.MinLoosenessAnusBuff, [2.0+0.5*(depth-1)])
	return buffs

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/AnalBeadsNiki/RestraintAnalBeads.gd").new()
	restraintData.setLevel(calculateBestRestraintLevel())

func getTakingOffStringLong(withS):
	if(withS):
		return "pulls the anal beads out from your butt"
	else:
		return "pull the anal beads out from your butt"

func getPuttingOnStringLong(withS):
	if(withS):
		return "inserts the anal beads into your butt"
	else:
		return "insert the anal beads into your butt"

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" was stuffed into your "+RNG.pick(["anus", "rear hole", "rear", "butt", "tailhole"])+". It shifts around while you move!"
	else:
		return getAStackNameCapitalize()+" was stuffed into {receiver.nameS} "+RNG.pick(["anus", "rear hole", "rear", "butt", "tailhole"])+". It shifts around while {receiver.he} {receiver.verbS('move')}!"

func getInventoryImage():
	return "res://Images/Items/bdsm/anal-plug.png"

func saveData():
	var data = .saveData()

	data["depth"] = depth
	data["length"] = length
	data["firstsize"] = firstsize
	data["numbered"] = numbered
	data["widening"] = widening
	data["isin"] = isin

	return data

func loadData(data):
	.loadData(data)

	depth = SAVE.loadVar(data, "depth", 1)
	length = SAVE.loadVar(data, "length", 5)
	firstsize = SAVE.loadVar(data, "firstsize", 1)
	numbered = SAVE.loadVar(data, "numbered", false)
	widening = SAVE.loadVar(data, "widening", false)
	isin = SAVE.loadVar(data, "isin", true)
