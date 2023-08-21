Class {
	#name : #TPDebuggerExtension,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'profiler',
		'profilerPane',
		'toolbarPane'
	],
	#category : #'TimeProfilerDebuggerXT-GUI'
}

{ #category : #initialization }
TPDebuggerExtension >> connectPresenters [

	toolbarPane onStartDo: [
		self
			contextMethod: debugger selectedContext
			runProfiler: profiler
			loops: toolbarPane iterations.
		profilerPane refresh ]
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethod: aContext runProfiler: aProfiler loops: aIterationNumber [

	aProfiler runBlock: [
		aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] ]
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
TPDebuggerExtension >> contextMethodText: aContext [

	^ 'On ',  aContext receiver asString
		, ' executing ', aContext method selector 
		, ' with arguments ', aContext arguments asString
]

{ #category : #'debugger extension' }
TPDebuggerExtension >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TPDebuggerExtension >> debuggerLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPane height: 160;
		  add: profilerPane;
		  yourself
]

{ #category : #'initialization - deprecated' }
TPDebuggerExtension >> initializePresenters [

	profiler := TimeProfiler new
		            withBlockCodePane: false;
		            withToolBar: false;
		            yourself.
	
	toolbarPane := TPDebuggerToolbar new.

	profilerPane := TimeProfilerPresenter new
		        profiler: profiler;
		        yourself.
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

	debugger selectedContext ifNotNil: [
		toolbarPane context:
			(self contextMethodText: debugger selectedContext).
		profiler reset.
		profilerPane refresh ]
]
