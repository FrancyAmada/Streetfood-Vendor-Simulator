extends Node

signal unlock_siomai()
signal unlock_juice()

signal minigame_started()
signal minigame_finished()

const OIL_LEVEL_FRYING_SPACE: Array[int] = [0, 10, 20, 30, 40]

const SIOMAI_UPGRADE_COST: int = 600

const JUICE_UPGRADE_COST: int = 300

const MALL_PERMIT_COST: int = 3000

const INTRO_STORY: String = "The sizzling scent of grilled skewers filled the air as you flipped them over the charcoal grill. A bead of sweat trickled down your temple, mirroring the anxiety in your heart. Your child, your precious one, lay sick in the hospital, each passing day a ticking time bomb. The doctor’s words echoed in your mind: “Ten thousand. That’s the amount you need.” With every skewer sold, you were inching closer to that life-saving figure. But the streets were unforgiving, and the competition was fierce. Would you be able to weather the storms, outsmart the odds, and save your child?"

const EVENTS: Dictionary = {
	"treatment": {
		"text": "You did it! With relentless effort and wise decisions, you’ve saved enough money to pay for your child’s treatment. As you hand over the hard-earned cash to the hospital, a wave of relief washes over you. You’ve conquered the streets, outwitted the odds, and become a hero to your family. Your child’s life is now secure, and you can finally breathe a sigh of relief.",
		"reward": -10000,
	},
	"broken_wheel": {
		"text": "Your cart wheel has suddenly broken down, making it impossible to move your cart. You'll need to spend some money to repair it before you can continue selling. This will delay your progress and cost you valuable time and money.",
		"reward": -100,
	},
	"generous_person": {
		"text": "A kind-hearted stranger, touched by your story, has offered you a generous sum of money to help with your child's medical expenses. This unexpected windfall will give you a much-needed boost and bring you closer to your goal.",
		"reward": 500,
	},
	"food_poisoning": {
		"text": "A group of customers who ate your food have fallen ill with food poisoning. This has tarnished your reputation and scared away potential customers. You'll need to take steps to regain their trust, which may involve offering refunds or discounts.",
		"reward": -500,
	},
}

func UNLOCK_SIOMAI():
	PlayerData.siomai_unlocked = true
	emit_signal("unlock_siomai")

func UNLOCK_JUICE():
	PlayerData.juice_unlocked = true
	emit_signal("unlock_juice")
