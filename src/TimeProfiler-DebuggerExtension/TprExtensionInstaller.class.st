Class {
	#name : #TprExtensionInstaller,
	#superclass : #Object,
	#category : #'TimeProfiler-DebuggerExtension-Installer'
}

{ #category : #installation }
TprExtensionInstaller class >> createExtensionClass [
	
	| extensionClass |
	
	"Creates the class"
	Smalltalk classInstaller make: [ :aBuilder |
		aBuilder
			superclass: SpPresenter;
			name: #TprDebuggerExtension;
			traitComposition: TStDebuggerExtension;
			slots: #(#profiler #profilerPane #toolbarPane);
			category: 'TimeProfiler-DebuggerExtension-Extension-UI' ].
	extensionClass := Smalltalk classNamed: 'TprDebuggerExtension'.
	
	"Add default required methods"
	extensionClass compile: 'debuggerExtensionToolName
		^ ''Time profiler''
	'.
	extensionClass compile: 'debuggerLayout
		^ SpBoxLayout newVertical
	'.
	
]

{ #category : #installation }
TprExtensionInstaller class >> install [

	<script: 'self install'>
	
	self createExtensionClass
]
