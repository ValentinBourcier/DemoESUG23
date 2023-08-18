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

{ #category : #'private - gui' }
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

{ #category : #'private - gui' }
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

{ #category : #'private - gui' }
TimeProfilerPresenter >> createComponents [

	profilerMorph := TimeProfilerMorph new model: profiler; yourself.

	self createTreeComponent.
	self createSummaryComponent.
	self createReportComponent.
	self createCodeComponent.
	self createBlockCodeComponent
]

{ #category : #'private - gui' }
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

{ #category : #'private - gui' }
TimeProfilerPresenter >> createSummaryComponent [

	summary := self specWrapperFor: (profilerMorph
		                newTextEditorFor: profiler
		                getText: #summaryText
		                setText: nil
		                getEnabled: nil)
]

{ #category : #'private - gui' }
TimeProfilerPresenter >> createTreeComponent [
	| treeMorph|
	treeMorph := profiler treeMorph
			         buildContents;
			         yourself.
	profiler treeMorph: treeMorph.
	tree := self specWrapperFor: (treeMorph).
]

{ #category : #'private - gui' }
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
	
	self layout: (SpBoxLayout newVertical
			 add: treeTabs;
			 add: codeTabs;
			 yourself)
]

{ #category : #api }
TimeProfilerPresenter >> profiler: aProfiler [

	profiler := aProfiler.
	self createComponents.
	self packComponents.
]

{ #category : #api }
TimeProfilerPresenter >> refresh [

	self profiler: profiler
]

{ #category : #'private - gui' }
TimeProfilerPresenter >> specWrapperFor: aMorph [
	
	^ self newMorph morph: aMorph; yourself
]
