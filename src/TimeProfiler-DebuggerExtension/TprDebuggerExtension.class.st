Class {
	#name : #TprDebuggerExtension,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'profiler',
		'profilerPane',
		'toolbarPane'
	],
	#category : #'TimeProfiler-DebuggerExtension-Extension-UI'
}

{ #category : #initialization }
TprDebuggerExtension >> connectPresenters [

	toolbarPane onStartDo: [
		self
			contextMethod: debugger selectedContext
			runProfiler: profiler
			loops: toolbarPane iterations.
		profilerPane refresh ]
]

{ #category : #'as yet unclassified' }
TprDebuggerExtension >> contextMethod: aContext runProfiler: aProfiler loops: aIterationNumber [

	aProfiler runBlock: [
		aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] ]
]

{ #category : #'as yet unclassified' }
TprDebuggerExtension >> contextMethodRun: aContext [

	[ 
		aContext receiver 
			perform: aContext method selector 
			withArguments: aContext arguments 
	] onErrorDo: [ nil ] 

]

{ #category : #'as yet unclassified' }
TprDebuggerExtension >> contextMethodText: aContext [

	^ 'On ',  aContext receiver asString
		, ' executing ', aContext method selector 
		, ' with arguments ', aContext arguments asString
]

{ #category : #'debugger extension' }
TprDebuggerExtension >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TprDebuggerExtension >> debuggerLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPane height: 160;
		  add: profilerPane;
		  yourself
]

{ #category : #'initialization - deprecated' }
TprDebuggerExtension >> initializePresenters [

	profiler := TimeProfiler new
		            withBlockCodePane: false;
		            withToolBar: false;
		            yourself.
	
	toolbarPane := TprDebuggerToolbar new.

	profilerPane := TimeProfilerSpPresenter new
		        profiler: profiler;
		        yourself.
]

{ #category : #'as yet unclassified' }
TprDebuggerExtension >> performProfileOf: aContext [

	profiler 
		runBlock: [ 1000 timesRepeat: [ self runContextMethod: aContext ] ] 
		pollingEvery: MessageTally defaultPollPeriod.
]

{ #category : #'as yet unclassified' }
TprDebuggerExtension >> runContextMethod: aContext [

	[ 
		aContext receiver
			perform: aContext method selector
			withArguments: aContext arguments 
	] 
	onErrorDo: [ nil ]
]

{ #category : #initialization }
TprDebuggerExtension >> updatePresenter [

	debugger selectedContext ifNotNil: [
		toolbarPane context:
			(self contextMethodText: debugger selectedContext).
		profiler reset.
		profilerPane refresh ]
]
