Class {
	#name : #TimeProfilerSpPresenter,
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
	#category : #'TimeProfiler-DebuggerExtension-TimeProfiler-UI'
}

{ #category : #accessing }
TimeProfilerSpPresenter >> clear [

	| originalProfiler |
	
	originalProfiler := profiler.
	
	"self profiler: TimeProfiler new
		withBlockCodePane: false; 
		yourself."
]

{ #category : #'private - gui' }
TimeProfilerSpPresenter >> createBlockCodeComponent [

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
TimeProfilerSpPresenter >> createCodeComponent [

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
TimeProfilerSpPresenter >> createComponents [

	profilerMorph := TprThemedModelMorph new model: profiler; yourself.

	self createTreeComponent.
	self createSummaryComponent.
	self createReportComponent.
	self createCodeComponent.
	self createBlockCodeComponent
]

{ #category : #'private - gui' }
TimeProfilerSpPresenter >> createReportComponent [

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
TimeProfilerSpPresenter >> createSummaryComponent [

	summary := self specWrapperFor: (profilerMorph
		                newTextEditorFor: profiler
		                getText: #summaryText
		                setText: nil
		                getEnabled: nil)
]

{ #category : #'private - gui' }
TimeProfilerSpPresenter >> createTreeComponent [
	| treeMorph|
	treeMorph := profiler treeMorph
			         buildContents;
			         yourself.
	profiler treeMorph: treeMorph.
	tree := self specWrapperFor: (treeMorph).
]

{ #category : #'private - gui' }
TimeProfilerSpPresenter >> packComponents [

	| mainLayout panedLayout |
	"Creates layouts"
	mainLayout := SpBoxLayout newVertical.
	panedLayout := SpPanedLayout newVertical
		               positionOfSlider: 0.7;
		               yourself.

	"Composes main layout"
	profiler withBlockCodePane ifTrue: [ mainLayout add: blockCode ].
	mainLayout add: panedLayout.

	"Composes paned layout"
	panedLayout add: (self newNotebook
			 addPageTitle: 'Tallies Tree' provider: [ tree ];
			 addPageTitle: 'Full report' provider: [ report ];
			 yourself).
	panedLayout add: (self newNotebook
			 addPageTitle: 'Code' provider: [ code ];
			 addPageTitle: 'Statistics' provider: [ summary ];
			 yourself).

	"Update the layout"
	self layout: mainLayout
]

{ #category : #api }
TimeProfilerSpPresenter >> profiler: aProfiler [

	profiler := aProfiler.
	self createComponents.
	self packComponents.
]

{ #category : #api }
TimeProfilerSpPresenter >> refresh [

	self profiler: profiler
]

{ #category : #'private - gui' }
TimeProfilerSpPresenter >> specWrapperFor: aMorph [
	
	^ self newMorph morph: aMorph; yourself
]
