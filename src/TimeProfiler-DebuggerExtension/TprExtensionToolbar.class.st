Class {
	#name : #TprExtensionToolbar,
	#superclass : #SpPresenter,
	#instVars : [
		'startBlock',
		'contextLabel',
		'startButton',
		'iterationsInput'
	],
	#category : #'TimeProfiler-DebuggerExtension-Extension-UI'
}

{ #category : #accessing }
TprExtensionToolbar >> context: aContextDescription [

	contextLabel text: aContextDescription
]

{ #category : #layout }
TprExtensionToolbar >> defaultLayout [

	^ SpBoxLayout newVertical
		spacing: 5;
		  add: 'Context' width: 100;
		  add: contextLabel height: 60;
		  add: (SpBoxLayout newHorizontal
				   add: 'Iterations' width: 100;
				   add: iterationsInput width: 100;
				   hAlignStart;
				   yourself)
		  height: 24;
		  add: startButton height: 34;
		  yourself
]

{ #category : #initialization }
TprExtensionToolbar >> initializePresenters [

	contextLabel := self newText beNotEditable.

	iterationsInput := self newNumberInput
		                   number: 1000;
		                   minimum: 0;
		                   climbRate: 100;
		                   yourself.

	startButton := self newButton
		               label: 'Start profiling';
		               icon: (self iconNamed: #glamorousGo);
		               action: startBlock;
		               yourself
]

{ #category : #accessing }
TprExtensionToolbar >> iterations [
	
	^ iterationsInput number
]

{ #category : #enumerating }
TprExtensionToolbar >> onStartDo: aBlock [

	startButton action: aBlock
]
