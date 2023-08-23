Class {
	#name : #BoxTest,
	#superclass : #TestCase,
	#category : #'DemoESUG23-Boxes'
}

{ #category : #tests }
BoxTest >> testMultipleBoxes [

	| random boxes |

	random := Random new seed: 101.

	"Create boxes"
	boxes := OrderedCollection new.
	10 timesRepeat: [ boxes add: Box new ].

	"Fill up the boxes with 10 random integers"
	boxes do: [ :b |
		10 timesRepeat: [ 
			b addElement: (random nextInteger: 10).
		].
		self haltIf: b = (Chest at: 'box').
	].

]
