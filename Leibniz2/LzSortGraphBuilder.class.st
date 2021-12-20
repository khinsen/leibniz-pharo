Class {
	#name : #LzSortGraphBuilder,
	#superclass : #Object,
	#instVars : [
		'subsortAxioms',
		'sortDeclarations',
		'includeDeclarations'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #building }
LzSortGraphBuilder >> build [
	self notYetImplemented
]

{ #category : #initializing }
LzSortGraphBuilder >> initialize [
	includeDeclarations :=
		OrderedCollection with: LzBuiltinContexts sortContext.
	sortDeclarations := OrderedCollection new.
	subsortAxioms := OrderedCollection new.
]

{ #category : #defining }
LzSortGraphBuilder >> sort: aString [
	| declaration |
	declaration := (LzParser newStartingAt: #sortOrSubsort) parse: aString.
	declaration isPetit2Failure ifTrue:
		[ self error: declaration message, ' after ',
				 (aString sliceFrom: 1 to: declaration position) ].
	declaration size = 1
		ifTrue: [ sortDeclarations add: declaration ]
		ifTrue: [ subsortAxioms add: declaration ].
]
