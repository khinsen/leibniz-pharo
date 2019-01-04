"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizContext class >> withName: aString withSortGraph: aSortGraph [
	^ self new withName: aString withSortGraph: aSortGraph.

]

{ #category : #accessing }
LeibnizContext >> name [
	^ name
]

{ #category : #printing }
LeibnizContext >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPut: $'.
	aStream nextPutAll: name.
	aStream nextPut: $'.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]

{ #category : #initializing }
LeibnizContext >> withName: aString withSortGraph: aSortGraph [
	name := aString.
	sortGraph := aSortGraph.
	self beRecursivelyReadOnlyObject.
]
