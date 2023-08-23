Class {
	#name : #ESUGDemo,
	#superclass : #Object,
	#category : #'DemoESUG23-Demo'
}

{ #category : #extension }
ESUGDemo class >> addContextMethodRun [

	self extensionClass compile: 'contextMethodRun: aContext

		[ 
			aContext receiver 
				perform: aContext method selector 
				withArguments: aContext arguments 
		] 
		onErrorDo: [ nil ] 
	'.	
	self protocolOrganizer classify: #contextMethodRun: inProtocolNamed: 'context'.
]

{ #category : #extension }
ESUGDemo class >> addContextMethodText [

	self extensionClass compile: 'contextMethodText: aContext

		^ ''On '',  aContext receiver asString
			, '' executing '', aContext method selector 
			, '' with arguments '', aContext arguments asString
	'.	
	self protocolOrganizer classify: #contextMethodText: inProtocolNamed: 'context'.
]

{ #category : #extension }
ESUGDemo class >> addContextProfiling [

	self addContextMethodRun.
	self extensionClass compile: 'contextMethod: aContext runProfiler: aProfiler loops: aIterationNumber

		aProfiler runBlock: [
			aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] 
		]
	'.
	self protocolOrganizer classify: #contextMethod:runProfiler:loops: inProtocolNamed: 'context'.
]

{ #category : #extension }
ESUGDemo class >> createExtensionClass [
	
	Smalltalk classInstaller make: [ :aBuilder |
		aBuilder
			superclass: SpPresenter;
			name: #TprDebuggerExtension;
			traitComposition: TStDebuggerExtension;
			slots: #(#profiler #profilerPane #toolbarPane);
			category: 'TimeProfiler-DebuggerExtension-Extension-UI' ].
	
]

{ #category : #extension }
ESUGDemo class >> extensionClass [

	^ Smalltalk classNamed: 'TprDebuggerExtension'
]

{ #category : #timeline }
ESUGDemo class >> extensionTimeline [

	"Prerequisite steps"
	self createExtensionClass.
	self overrideToolName.
	
	"Activate the extension"
	
	"Initialization steps"
	self overrideInitialization.
	self overrideLayout.
	
	
	"How to analyse the debugging context ?"
	"Inspector ? No, Chest !"
	
	
	"Bind the selection of a debugging context with the toolbar"
	self addContextMethodText.
	self overrideToolbarUpdate.
	
	"Bing the toolbar with the profiler pane"
	self addContextProfiling.
	self overrideConnectPresenters.
	
	"Bind the selection of a debugging context with the refreshing of the profiler pane"
	self overrideProfilerUpdate.
	
	

]

{ #category : #extension }
ESUGDemo class >> overrideConnectPresenters [

	self extensionClass compile: 'connectPresenters
		
		toolbarPane onStartDo: [
			self
				contextMethod: debugger selectedContext
				runProfiler: profiler
				loops: toolbarPane iterations.
			profilerPane refresh
		]
	'.
	self protocolOrganizer classify: #connectPresenters inProtocolNamed: 'presenters'.
]

{ #category : #extension }
ESUGDemo class >> overrideInitialization [

	self extensionClass compile: 'initializePresenters

		"Configuration"
		profiler := TimeProfiler new
		            withBlockCodePane: false;
		            withToolBar: false;
		            yourself.
		"Widgets"
		toolbarPane := TprExtensionToolbar new.
		profilerPane := TimeProfilerSpPresenter new
		                profiler: profiler;
		                yourself
	'.
	self protocolOrganizer classify: #initializePresenters inProtocolNamed: 'presenters'.

]

{ #category : #extension }
ESUGDemo class >> overrideLayout [

	self extensionClass compile: 'debuggerLayout
	
		^ SpBoxLayout newVertical
			  add: toolbarPane height: 160;
			  add: profilerPane;
			  yourself
	'
]

{ #category : #extension }
ESUGDemo class >> overrideProfilerUpdate [

	self extensionClass compile: 'updatePresenter
	
		debugger selectedContext ifNotNil: [
			toolbarPane context: (self contextMethodText: debugger selectedContext).
			profiler reset.
			profilerPane refresh
		]
	'.
	self protocolOrganizer classify: #updatePresenter inProtocolNamed: 'presenters'.
]

{ #category : #extension }
ESUGDemo class >> overrideToolName [

	self extensionClass compile: 'debuggerExtensionToolName
	
		^ ''Time profiler''
	'.

]

{ #category : #extension }
ESUGDemo class >> overrideToolbarUpdate [

	self extensionClass compile: 'updatePresenter
	
		debugger selectedContext ifNotNil: [
			toolbarPane context: (self contextMethodText: debugger selectedContext).
		]
	'.
	self protocolOrganizer classify: #updatePresenter inProtocolNamed: 'presenters'.
]

{ #category : #extension }
ESUGDemo class >> protocolOrganizer [

	^ self extensionClass organization protocolOrganizer
]

{ #category : #extension }
ESUGDemo class >> removeExtension [

	Smalltalk removeClassNamed: 'TprDebuggerExtension'
]

{ #category : #timeline }
ESUGDemo class >> timeline [
	
	"How the Pharo debugger looks like"
	'ESUG23' crTrace.
	
	"What about adding performance statistics ?"
	TimeProfiler spyOn: [ 'ESUG23' crTrace ].
	
	"No figures ?"
	TimeProfiler spyOn: [ 10000 timesRepeat: [ 'ESUG23' crTrace ] ].
	
	"Disclaimer - prepared UI"
	TprExtensionToolbar new open.
	TimeProfilerSpPresenter new 
		profiler: (TimeProfiler new withBlockCodePane: false; yourself);
		open.
]
