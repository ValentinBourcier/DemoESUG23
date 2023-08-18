Class {
	#name : #TimeProfilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'profiler',
		'profilerMorph',
		'tree',
		'summary',
		'report',
		'code',
		'blockCode',
		'panel'
	],
	#category : #TimeProfilerDebuggerXT
}

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> createBlockCodeComponent [

	| blockCodePaneMorph |
	blockCodePaneMorph := profilerMorph
		                      newTextEditorFor: profiler
		                      getText: #blockCode
		                      setText: #blockCode:notifying:
		                      getEnabled: nil.
	blockCodePaneMorph getMenuSelector: #codePaneMenu:shifted:.
	blockCodePaneMorph font: StandardFonts codeFont.
	blockCodePaneMorph alwaysAccept: true.
	blockCode := self specWrapperFor: blockCodePaneMorph
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> createCodeComponent [

	|codePaneMorph|
	codePaneMorph := profilerMorph
		                 newTextEditorFor: profiler
		                 getText: #selectedMethodCode
		                 setText: #selectedMethodCode:notifying:
		                 getEnabled: nil.
	codePaneMorph getMenuSelector: #codePaneMenu:shifted:.
	codePaneMorph font: StandardFonts codeFont.
	code := self specWrapperFor: codePaneMorph
]

{ #category : #initialization }
TimeProfilerPresenter >> createComponents [

	profilerMorph := TimeProfilerMorph new model: profiler.

	self createTreeComponent.
	self createSummaryComponent.
	self createReportComponent.
	self createCodeComponent.
	self createBlockCodeComponent
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> createReportComponent [

	| fullReportMorph |
	fullReportMorph := profilerMorph
		                   newTextEditorFor: profiler
		                   getText: #fullReport
		                   setText: nil
		                   getEnabled: nil.
	fullReportMorph getMenuSelector: #fullReportMenu:shift:.
	report := self specWrapperFor: fullReportMorph
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> createSummaryComponent [

	summary := self specWrapperFor: (profilerMorph
		                newTextEditorFor: profiler
		                getText: #summaryText
		                setText: nil
		                getEnabled: nil)
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> createTreeComponent [
	| treeMorph|
	treeMorph := profiler treeMorph
			         buildContents;
			         yourself.
	profiler treeMorph: treeMorph.
	tree := self specWrapperFor: (treeMorph).
]

{ #category : #layout }
TimeProfilerPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : #initialization }
TimeProfilerPresenter >> packComponents [

	| treeTabs codeTabs |
	profiler withBlockCodePane ifTrue: [ panel add: blockCode ].

	treeTabs := self newNotebook
		            addPageTitle: 'Tallies Tree' provider: [ tree ];
		            addPageTitle: 'Full report' provider: [ report ];
		            yourself.
	codeTabs := self newNotebook
		            addPageTitle: 'Code' provider: [ code ];
		            addPageTitle: 'Statistics' provider: [ summary ];
		            yourself.
	
	self layout add: treeTabs.
	self layout add: codeTabs
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> profiler: aProfiler [

	profiler := aProfiler.
	self createComponents.
	self packComponents.
]

{ #category : #'as yet unclassified' }
TimeProfilerPresenter >> specWrapperFor: aMorph [
	
	^ self newMorph morph: aMorph; yourself
]
