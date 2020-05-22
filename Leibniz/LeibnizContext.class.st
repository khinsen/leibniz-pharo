"
I represent a context in a Leibniz document.
"
Class {
	#name : #LeibnizContext,
	#superclass : #Object,
	#instVars : [
		'name',
		'sortGraph',
		'signature',
		'rewriteSystem'
	],
	#category : #'Leibniz-6-Contexts'
}

{ #category : #'instance creation' }
LeibnizContext class >> name: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem [
	^ self basicNew
			 initializeWithName: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem;
			 yourself.

]

{ #category : #inspecting }
LeibnizContext >> gtInspectorComponentsIn: composite [
	"Show a list of all components of a context"

	<gtInspectorPresentationOrder: 0>
	composite fastTree 
		title: 'Components';
		display: { sortGraph . signature };
		children: [ :each | each childrenInInspector ] ;
		format: #title
]

{ #category : #initializing }
LeibnizContext >> initializeWithName: aString sortGraph: aSortGraph signature: aSignature rewriteSystem: aRewriteSystem [
	name := aString.
	sortGraph := aSortGraph.
	signature := aSignature.
	rewriteSystem := aRewriteSystem.
	self beRecursivelyReadOnlyObject.
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
LeibnizContext >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LeibnizContext >> signature [
	^signature

]

{ #category : #accessing }
LeibnizContext >> sortGraph [
	^ sortGraph
]
