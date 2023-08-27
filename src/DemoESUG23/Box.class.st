Class {
	#name : #Box,
	#superclass : #Object,
	#instVars : [
		'name',
		'elements'
	],
	#category : #'DemoESUG23-Boxes'
}

{ #category : #comparing }
Box >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	name = anObject name ifFalse: [ ^false ].
	^ elements = anObject elements
]

{ #category : #adding }
Box >> addElement: anObject [

	elements add: anObject.
	name := 'Box of ', elements size printString, ' elements'
]

{ #category : #accessing }
Box >> elements [

	^ elements
]

{ #category : #adding }
Box >> initialize [
	
	name := ''.
	elements := OrderedCollection new	
]

{ #category : #accessing }
Box >> name [
	^ name
]

{ #category : #adding }
Box >> name: aName [

	name := aName
]

{ #category : #adding }
Box >> printString [

	^ name
]

{ #category : #adding }
Box >> removeElement: anObject [

	elements remove: anObject.
	name := 'Box of ', elements size, ' elements'
]
