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
			contextMethod: debugger context
			runProfiler: profiler
			loops: 10000.
		profilerPane refresh ]
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethod: aContext runProfiler: aProfiler loops: aIterationNumber [

	aProfiler runBlock: [
		aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] ]
]

{ #category : #'as yet unclassified' }
TPDebuggerExtension >> contextMethodText: aContext [

	| action args |
	action := aContext method selector.
	args := aContext arguments.
	^ 'Method: ' , action , ' with: ', args asString
]

{ #category : #'debugger extension' }
TPDebuggerExtension >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TPDebuggerExtension >> debuggerLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPane expand: false;
		  add: profilerPane;
		  yourself
]

{ #category : #initialization }
TPDebuggerExtension >> updatePresenter [

	toolbarPane method: (self contextMethodText: debugger context)
]
