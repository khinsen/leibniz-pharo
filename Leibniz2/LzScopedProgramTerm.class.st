Class {
	#name : #LzScopedProgramTerm,
	#superclass : #LzProgramTerm,
	#instVars : [
		'scope',
		'tempVars'
	],
	#classVars : [
		'Counter'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzScopedProgramTerm class >> newScopePrefix [
	Counter := 1 + (Counter ifNil: 0).
	^ LzConstants tempVarPrefix, Counter asString
]

{ #category : #initializing }
LzScopedProgramTerm >> initialize [
	super initialize.
	self scope: self class newScopePrefix
]

{ #category : #accessing }
LzScopedProgramTerm >> scope [
	^ scope
]

{ #category : #accessing }
LzScopedProgramTerm >> scope: anObject [
	scope := anObject
]

{ #category : #accessing }
LzScopedProgramTerm >> steps: anArray fromScope: aSymbol [
	| rename |
	rename := self signature emptyBindings.
	tempVars keysAndValuesDo: [ :eachName :eachSort |
		| oldName |
		oldName := aSymbol
			ifNil: [ eachName ]
			ifNotNil: [ eachName addScope: aSymbol ].
		rename defineVar: eachName sort: eachSort.
		rename
			bindVar: eachName
			sort: eachSort
			to: (LzVarTerm new
					signature: self signature;
					name: (eachName addScope: self scope);
					sort: eachSort;
					beRecursivelyReadOnlyObject;
					yourself) ].
	self steps:
		(anArray collect: [ :each |
			{ each first substitute: rename
			. each second ifNotNil: [ :p | p substitute: rename ] } ]).

]

{ #category : #accessing }
LzScopedProgramTerm >> tempVars [
	^ tempVars
]

{ #category : #accessing }
LzScopedProgramTerm >> tempVars: anObject [
	tempVars := anObject
]

{ #category : #transforming }
LzScopedProgramTerm >> withTransformedArgs: anArgList [
	| transformedSteps |
	self assert: (anArgList size \\ 2) equals: 0.
	transformedSteps := (anArgList groupsOf: 2) collect: [ :each |
		{ each first
		. (each second = self noPattern)
			ifTrue: [ nil ]
			ifFalse: [ each second] } ].
	^ LzScopedProgramTerm new
		signature: self signature;
		tempVars: self tempVars;
		steps: transformedSteps fromScope: self scope;
		checkSteps;
		computeSort;
		beRecursivelyReadOnlyObject;
		yourself
]
