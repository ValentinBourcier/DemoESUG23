Class {
	#name : #TPDebuggerToolbar,
	#superclass : #SpPresenter,
	#instVars : [
		'iterations',
		'start',
		'method',
		'startBlock'
	],
	#category : #'TimeProfilerDebuggerXT-GUI'
}

{ #category : #layout }
TPDebuggerToolbar >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   add: 'Method';
				   add: method;
				   yourself)
		  height: 24;
		  add: (SpBoxLayout newHorizontal
				   add: 'Iterations';
				   add: iterations width: 100;
				   yourself)
		  height: 24;
		  add: start height: 34;
		  yourself
]

{ #category : #initialization }
TPDebuggerToolbar >> initializePresenters [

	method := self newLabel.

	iterations := self newNumberInput
		              number: 1000;
		              minimum: 0;
		              climbRate: 100;
		              yourself.

	start := self newButton
		         label: 'Start profiling';
		         icon: (self iconNamed: #glamorousGo);
		         action: startBlock;
		         yourself
]

{ #category : #accessing }
TPDebuggerToolbar >> method: aMethodString [

	method label: aMethodString
]

{ #category : #enumerating }
TPDebuggerToolbar >> onStartDo: aBlock [

	start action: aBlock
]
