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
	].

	self assert: (boxes at: 5) elements equals: #(10 3 10 1 9 4 8 4 6 1) asOrderedCollection
]
