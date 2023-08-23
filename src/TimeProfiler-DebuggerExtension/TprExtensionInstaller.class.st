Class {
	#name : #TprExtensionInstaller,
	#superclass : #Object,
	#category : #'TimeProfiler-DebuggerExtension-Installer'
}

{ #category : #adding }
TprExtensionInstaller class >> addContextMethodRun [

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

{ #category : #adding }
TprExtensionInstaller class >> addContextMethodText [

	self extensionClass compile: 'contextMethodText: aContext

		^ ''On '',  aContext receiver asString
			, '' executing '', aContext method selector 
			, '' with arguments '', aContext arguments asString
	'.	
	self protocolOrganizer classify: #contextMethodText: inProtocolNamed: 'context'.
]

{ #category : #adding }
TprExtensionInstaller class >> addContextProfiling [

	self addContextMethodRun.
	self extensionClass compile: 'contextMethod: aContext runProfiler: aProfiler loops: aIterationNumber

		aProfiler runBlock: [
			aIterationNumber timesRepeat: [ self contextMethodRun: aContext ] 
		]
	'.
	self protocolOrganizer classify: #contextMethod:runProfiler:loops: inProtocolNamed: 'context'.
]

{ #category : #installation }
TprExtensionInstaller class >> createExtensionClass [
	
	Smalltalk classInstaller make: [ :aBuilder |
		aBuilder
			superclass: SpPresenter;
			name: #TprDebuggerExtension;
			traitComposition: TStDebuggerExtension;
			slots: #(#profiler #profilerPane #toolbarPane);
			category: 'TimeProfiler-DebuggerExtension-Extension-UI' ].
	
]

{ #category : #accessing }
TprExtensionInstaller class >> extensionClass [

	^ Smalltalk classNamed: 'TprDebuggerExtension'
]

{ #category : #installation }
TprExtensionInstaller class >> install [

	<script: 'self install'>
	
	"Prerequisite steps"
	self createExtensionClass.
	self overrideToolName.
	
	"Initialization steps"
	self overrideInitialization.
	self overrideLayout.
	
	"Bind the selection of a debugging context with the toolbar"
	self addContextMethodText.
	self overrideToolbarUpdate.
	
	"Bing the toolbar with the profiler pane"
	self addContextProfiling.
	self overrideConnectPresenters.
	
	"Bind the selection of a debugging context with the refreshing of the profiler pane"
	self overrideProfilerUpdate.
	
	

]

{ #category : #overrides }
TprExtensionInstaller class >> overrideConnectPresenters [

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

{ #category : #overrides }
TprExtensionInstaller class >> overrideInitialization [

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

{ #category : #overrides }
TprExtensionInstaller class >> overrideLayout [

	self extensionClass compile: 'debuggerLayout
	
		^ SpBoxLayout newVertical
			  add: toolbarPane height: 160;
			  add: profilerPane;
			  yourself
	'
]

{ #category : #overrides }
TprExtensionInstaller class >> overrideProfilerUpdate [

	self extensionClass compile: 'updatePresenter
	
		debugger selectedContext ifNotNil: [
			toolbarPane context: (self contextMethodText: debugger selectedContext).
			profiler reset.
			profilerPane refresh
		]
	'.
	self protocolOrganizer classify: #updatePresenter inProtocolNamed: 'presenters'.
]

{ #category : #overrides }
TprExtensionInstaller class >> overrideToolName [

	self extensionClass compile: 'debuggerExtensionToolName
	
		^ ''Time profiler''
	'.

]

{ #category : #overrides }
TprExtensionInstaller class >> overrideToolbarUpdate [

	self extensionClass compile: 'updatePresenter
	
		debugger selectedContext ifNotNil: [
			toolbarPane context: (self contextMethodText: debugger selectedContext).
		]
	'.
	self protocolOrganizer classify: #updatePresenter inProtocolNamed: 'presenters'.
]

{ #category : #accessing }
TprExtensionInstaller class >> protocolOrganizer [

	^ self extensionClass organization protocolOrganizer
]
