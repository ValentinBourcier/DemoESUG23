Class {
	#name : #TPDebuggerExtension,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'button',
		'profiler',
		'win',
		'pane',
		'method'
	],
	#category : #TimeProfilerDebuggerXT
}

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethodProfile: aContext loops: aIterationNumber [

	profiler runBlock: [
		aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] 
	]
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethodRun: aContext [

	[ 
		aContext receiver 
			perform: aContext method selector 
			withArguments: aContext arguments 
	] onErrorDo: [ nil ] 

]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethodString: aContext [

	^ 'Method: #' , aContext method selector , ' with: '
	  , aContext arguments asOrderedCollection asString 
]

{ #category : #'debugger extension' }
TPDebuggerExtension >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TPDebuggerExtension >> debuggerLayout [

	^ SpBoxLayout newVertical
		add: method;
		  add: pane;
		  yourself
]

{ #category : #'initialization - deprecated' }
TPDebuggerExtension >> initializePresenters [

	profiler := TimeProfiler new
		            withBlockCodePane: false;
		            withToolBar: false;
		            yourself.
	method := self newLabel.
	pane := TimeProfilerPresenter new
		        profiler: profiler;
		        yourself.
]

{ #category : #initialization }
TPDebuggerExtension >> updatePresenter [

	| context |
	context := debugger context.

	self contextMethodProfile: context loops: 100000.
	method label: (self contextMethodString: context).

	pane refresh
]
