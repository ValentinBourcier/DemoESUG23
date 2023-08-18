Class {
	#name : #TPDebuggerPresenter,
	#superclass : #SpPresenter,
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'button'
	],
	#category : #TimeProfilerDebuggerXT
}

{ #category : #'debugger extension' }
TPDebuggerPresenter >> debuggerExtensionToolName [

	^ 'Time profiler' 
]

{ #category : #layout }
TPDebuggerPresenter >> debuggerLayout [

	^ SpBoxLayout newVertical
]
