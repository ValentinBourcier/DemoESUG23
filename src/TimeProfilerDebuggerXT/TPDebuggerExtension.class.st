Class {
	#name : #TPDebuggerExtension,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'button',
		'profiler',
		'win',
		'pane'
	],
	#category : #TimeProfilerDebuggerXT
}

{ #category : #'debugger extension' }
TPDebuggerExtension >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TPDebuggerExtension >> debuggerLayout [

	^ SpBoxLayout newVertical
		  add: pane;
		  yourself
]

{ #category : #'initialization - deprecated' }
TPDebuggerExtension >> initializePresenters [

	profiler := TimeProfiler new
		            withBlockCodePane: false;
		            withToolBar: false;
		            yourself.
	pane := TimeProfilerPresenter new
		        profiler: profiler;
		        yourself
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> performProfileOf: aContext [

	profiler 
		runBlock: [ 1000 timesRepeat: [ self runContextMethod: aContext ] ] 
		pollingEvery: MessageTally defaultPollPeriod.
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> runContextMethod: aContext [

	[ 
		aContext receiver
			perform: aContext method selector
			withArguments: aContext arguments 
	] 
	onErrorDo: [ nil ]
]

{ #category : #initialization }
TPDebuggerExtension >> updatePresenter [

	profiler ifNotNil: [
		self performProfileOf: debugger context.
		profiler startState ]
]
