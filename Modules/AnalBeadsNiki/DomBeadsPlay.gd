extends SexActivityBase

var pcUniqueID:String = ""
var npcItemID:String = ""

var usedBodypartNames = ["anus", "tailhole", "backdoor", "star", "anal ring"]

var beads:ItemBase = null
var depth:int = 1
var maxDepth:int = 1

func _init():
	id = "DomBeadsPlay"
	startedByDom = true
	startedBySub = false
	
	activityName = "Beads play"
	activityCategory = ["Beads"]

#Feels kinda right :/
func sizeToDiameter(size:float) -> float:
	return sqrt(size-10.0)

func diameterToSize(diameter:float) -> float:
	return 10.0 + pow(diameter, 2.0)

func getFittingChance(who:BaseCharacter,insertionDiameter:float) -> float:
	var chance = who.getPenetrateChance(BodypartSlot.Anus,diameterToSize(insertionDiameter))
	# print(insertionDiameter,diameterToSize(insertionDiameter),chance)
	return chance

func getOrificeStretchedTo(who:BaseCharacter,insertionDiameter:float,stretchMult:float=1.0):
	who.gotOrificeStretchedWith(BodypartSlot.Anus, diameterToSize(insertionDiameter), true, stretchMult)

func pullingOneByOneText() -> String:
	var text:String = "Plup."
	for _i in range(depth-1):
		text += " Plup."
	return text



func getGoals():
	return {
	}

func getTags(_indx:int) -> Array:
	if(_indx == DOM_0):
		return [SexActivityTag.HandsUsed]
	return []

func getSupportedSexTypes():
	return {
		SexType.DefaultSex: true,
		SexType.StocksSex: true,
		SexType.SlutwallSex: true,
	}

#WILL RE-DO
func getStartActions(_sexEngine: SexEngine, _domInfo: SexDomInfo, _subInfo: SexSubInfo):
	var actions = []
	var dom:BaseCharacter = _domInfo.getChar()
	var sub:BaseCharacter = _subInfo.getChar()

	if(dom.isPlayer() && !dom.hasBlockedHands() && !dom.hasBoundArms()):
		for item in sub.getInventory().getEquippedRestraints():
			if item.id == "AnalBeads":
				addStartAction([sub], 'Beads Play', 'Play with the anal beads in their ass', 1.0, {A_CATEGORY: ["Beads"]})
				
	return actions 

func startActivity(_args):
	addText("{dom.You} {dom.youVerb('take','takes')} hold on the bead strings hanging from {sub.your} ass")
	for item in _args[0].getInventory().getEquippedRestraints():
		if item.id == "AnalBeads":
			beads = item
			depth = 1
			return
	assert(false)

func getActions(_indx:int):
	var dom:BaseCharacter = doms[0].getChar()
	var sub:BaseCharacter = subs[0].getChar() #_subInfo.getChar()
	var ok = 0

	maxDepth = beads.length
	
	for item in sub.getInventory().getEquippedRestraints():
		if item.id == "AnalBeads": ok = 1
	if !ok: endActivity()
	
	#if reachable 
	#?and handsfree
	ok = 0
	for act in getSexEngine().activities:
		# if (act.id == "SexVaginalOnAllFours"): #doesnt work anyway || act.id =="SexAnalOnAllFours"):
		# 	if (!act.currentPose in ["POSE_MISSIONARY","POSE_FULLNELSON","POSE_MATINGPRESS","POSE_LEGRAISED","POSE_WALLPRESS","POSE_CHOKEFUCK"]):
		# 		ok = 1
		# elif (true):
		# 	ok = 1
		if (true): #ignore for now
			ok = 1
	if ok:
		# print(act.id)
		if(!dom.hasBlockedHands() && !dom.hasBoundArms()):
			if depth < maxDepth:
				addAction("More",1,"Push in","Push one bead in",{A_CATEGORY: ["Beads"]})
			if depth > 0:
				addAction("Less",1,"Pull out","Pull one bead out",{A_CATEGORY: ["Beads"]})
			if depth > 1:
				addAction("All",1,"Yoink","Forcefully pull out all beads at once",{A_CATEGORY: ["Beads"]})

func doAction(_indx:int, _actionID:String, _action:Dictionary):
	var beadsize:float = beads.firstsize
	var beadspain:int = 0
	
	if beads.widening:
		beadsize += depth*0.5

	if (_actionID == "More"):
		if (RNG.chance(getFittingChance(getSub(),beadsize))):
			depth += 1
			stimulate(0,'none',-1,BodypartSlot.Anus,I_LOW,Fetish.AnalSexGiving,SPEED_SLOW)
			getOrificeStretchedTo(getSub(),beadsize,0.2)
			addText(RNG.pick([
					"{dom.You} {dom.youVerb('manage','manages')} to fit next bead in {sub.your} "+RNG.pick(usedBodypartNames)+".",
					"{dom.You} {dom.youVerb('shove','shoves')} one more bead inside {sub.your} "+RNG.pick(usedBodypartNames)+".",
				]))

		elif (RNG.chance(30)):
			depth += 1
			stimulate(0,'none',-1,BodypartSlot.Anus,I_LOW,Fetish.AnalSexGiving,SPEED_SLOW)
			getOrificeStretchedTo(getSub(),beadsize,0.2)
			beadspain = RNG.randi_range(4,8) #more?
			getSub().addPain(beadspain)
			sendSexEvent(SexEvent.PainInflicted, SUB_0, DOM_0, {pain=beadspain,isDefense=false,intentional=false})
			addText(RNG.pick([
					"{dom.You} {dom.youVerb('manage','manages')} to forcefully push the next bead in {sub.your} "+RNG.pick(usedBodypartNames)+".",
					"With some resistance {dom.you} {dom.youVerb('shove','shoves')} one more bead inside {sub.your} "+RNG.pick(usedBodypartNames)+".",
				]))

		else:
			stimulate(0,'none',-1,BodypartSlot.Anus,I_TEASE,Fetish.AnalSexGiving,SPEED_SLOW)
			getOrificeStretchedTo(getSub(),beadsize,0.1)
			addText("{dom.You} {dom.youVerb('stretch','stretches')} {sub.your} "+RNG.pick(usedBodypartNames)+" out while trying to fit a bead inside.")

	#One size less for pulling
	if beads.widening:
		beadsize -= 0.5

	if (_actionID == "Less"):
		depth -= 1
		# if (RNG.chance(getFittingChance(getSub(),beadsize))):
		# 	depth -= 1
		# 	stimulate(0,'none',-1,BodypartSlot.Anus,I_LOW,Fetish.AnalSexGiving,SPEED_SLOW)
		# 	getOrificeStretchedTo(getSub(),beadsize,0.2)
		# 	addText(RNG.pick([
		# 			"{dom.You} {dom.youVerb('manage','manages')} to fit next bead in {sub.your} "+RNG.pick(usedBodypartNames)+".",
		# 			"{dom.You} {dom.youVerb('shove','shoves')} one more bead inside {sub.your} "+RNG.pick(usedBodypartNames)+".",
		# 		]))

		# elif (RNG.chance(30)):
		# 	depth -= 1
		# 	stimulate(0,'none',-1,BodypartSlot.Anus,I_LOW,Fetish.AnalSexGiving,SPEED_SLOW)
		# 	getOrificeStretchedTo(getSub(),beadsize,0.2)
		# 	beadspain = RNG.randi_range(4,8) #more?
		# 	getSub().addPain(beadspain)
		# 	sendSexEvent(SexEvent.PainInflicted, SUB_0, DOM_0, {pain=beadspain,isDefense=false,intentional=false})
		# 	addText(RNG.pick([
		# 			"{dom.You} {dom.youVerb('manage','manages')} to forcefullt the push next bead in {sub.your} "+RNG.pick(usedBodypartNames)+".",
		# 			"With some resistance {dom.you} {dom.youVerb('shove','shoves')} one more bead inside {sub.your} "+RNG.pick(usedBodypartNames)+".",
		# 		]))

		# else:
		# 	stimulate(0,'none',-1,BodypartSlot.Anus,I_TEASE,Fetish.AnalSexGiving,SPEED_SLOW)
		# 	getOrificeStretchedTo(getSub(),beadsize,0.1)
		# 	addText("{dom.You} {dom.youVerb('stretch','stretches')} {sub.your} "+RNG.pick(usedBodypartNames)+" out while trying to fit a bead inside.")

	if (_actionID == "All"):
		if (RNG.chance(getFittingChance(getSub(),beadsize))):
			var oneByOne = pullingOneByOneText()
			depth = 0
			#? for each bead
			var intensity = [I_TEASE,I_LOW,I_NORMAL,I_HIGH][min(depth+1,3)] #I know that's exessive...
			stimulate(0,'none',-1,BodypartSlot.Anus,intensity,Fetish.Sadism,SPEED_FAST)
			getOrificeStretchedTo(getSub(),beadsize,0.15) 
			for _i in range(depth):
				#? depending on loosnes
				if beads.widening:
					beadspain += RNG.randi_range(4,8) + int(round(0.5 + float(depth)*0.5))
				else:
					beadspain += RNG.randi_range(4,8)
			getSub().addPain(beadspain)
			sendSexEvent(SexEvent.PainInflicted, SUB_0, DOM_0, {pain=beadspain,isDefense=false,intentional=true})
			addText(RNG.pick([
					"{dom.You} forcefully {dom.youVerb('yoink','yoinks')} the whole chain of beads out of {sub.your} "+RNG.pick(usedBodypartNames)+".",
					"{dom.You} {dom.youVerb('pull','pulls')} all the beads from {sub.your} "+RNG.pick(usedBodypartNames)+" at once.",
					oneByOne,
				]))

			#? extra lust and text for pulling max length

		#? extra chance but painfull
		# elif (RNG.chance(???)):

		#? extra chance but partially
		# elif (RNG.chance(???)):

		else:
			stimulate(0,'none',-1,BodypartSlot.Anus,I_TEASE,Fetish.AnalSexGiving,SPEED_FAST)
			getOrificeStretchedTo(getSub(),beadsize,0.15)
			addText("{dom.You} {dom.youVerb('fail','fails')} to yoink out the beads and {dom.youVerb('stretch','stretches')} {sub.your} "+RNG.pick(usedBodypartNames)+" out a bit.")

	if (beadspain > 0):
		addText(" Ouch.")

	if (getDom().isPlayer()):
		var stillIn = str(maxDepth-depth)
		var text = ""
		if (maxDepth-depth == 0):
			text = "You can see only anal beads' string hanging out of {sub.your} ass."
		elif (depth == 0):
			text = "You are holding a chain of "+str(maxDepth)+" beads in your hand."
		elif (maxDepth-depth > 1):
			text = "You can see "+stillIn+ " beads still hanging outside of {sub.your} ass."
		else: 
			text = "You can see only 1 bead still hanging outside of {sub.your} ass."
		if false: text = "\n"+text
		addText(text)

	if depth == 0: beads.isin = false
	else: beads.isin = true
	beads.depth = depth

func saveData():
	var data = .saveData()

	# data["beads"] = beads
	data["depth"] = depth

	return data

func loadData(data):
	.loadData(data)

	# beads = SAVE.loadVar(data, "beads", "")
	depth = SAVE.loadVar(data, "depth", 1)

	for item in getSub().getInventory().getEquippedRestraints():
		if item.id == "AnalBeads":
			beads = item
			depth = 1
