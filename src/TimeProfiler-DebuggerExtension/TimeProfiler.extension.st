Extension { #name : #TimeProfiler }

{ #category : #'*TimeProfiler-DebuggerExtension' }
TimeProfiler >> reset [

	result := nil.
	block := nil.
	blockSource := nil.
	rootMessageTally := nil
]

{ #category : #'*TimeProfiler-DebuggerExtension' }
TimeProfiler >> treeMorph: aMorph [

	treeMorph := aMorph
	
]
