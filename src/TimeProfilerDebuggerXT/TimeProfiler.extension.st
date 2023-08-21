Extension { #name : #TimeProfiler }

{ #category : #'*TimeProfilerDebuggerXT' }
TimeProfiler >> reset [

	result := nil.
	block := nil.
	blockSource := nil.
	rootMessageTally := nil
]

{ #category : #'*TimeProfilerDebuggerXT' }
TimeProfiler >> treeMorph: aMorph [

	treeMorph := aMorph
	
]
