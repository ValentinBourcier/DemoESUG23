Class {
	#name : #TPDebuggerToolbar,
	#superclass : #SpPresenter,
	#instVars : [
		'startBlock',
		'contextLabel',
		'startButton',
		'iterationsInput'
	],
	#category : #'TimeProfilerDebuggerXT-GUI'
}

{ #category : #accessing }
TPDebuggerToolbar >> context: aContextDescription [

	contextLabel text: aContextDescription
]

{ #category : #layout }
TPDebuggerToolbar >> defaultLayout [

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
TPDebuggerToolbar >> initializePresenters [

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
TPDebuggerToolbar >> iterations [
	
	^ iterationsInput number
]

{ #category : #enumerating }
TPDebuggerToolbar >> onStartDo: aBlock [

	startButton action: aBlock
]
