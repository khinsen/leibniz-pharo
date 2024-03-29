"
I represent an abstract Leibniz term. My subclasses represent concrete terms. 
"
Class {
	#name : #LbTerm,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : #matching }
LbTerm >> addPrefix: aSymbol toVarsConflictingWith: anotherTerm [
	| substitution myVars otherVars |
	myVars := self variables.
	otherVars := anotherTerm variables.
	substitution := LbVariables new.
	(myVars keys intersection: otherVars keys)
		ifNotEmpty: [ :conflicts |
			conflicts do: [ :each |
				| newName sort | [
					newName := each addPrefix: aSymbol.
					otherVars includes: newName
				] whileTrue.
				sort := myVars at: each.
				substitution defineVar: each sort: sort.
				substitution
					bindVar: each
					ofSort: sort
					to: (LbVarTerm
							name: newName
							sort: sort
							signature: self signature) ] ].
	^ substitution
]

{ #category : #accessing }
LbTerm >> arguments [
	^ #()
]

{ #category : #converting }
LbTerm >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #matching }
LbTerm >> assertNotAVariable [
	^ self
]

{ #category : #converting }
LbTerm >> convertToSignature: aSignature [
	^ self convertToSignature: aSignature extraVariables: Dictionary new.
]

{ #category : #converting }
LbTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	self subclassResponsibility
]

{ #category : #copying }
LbTerm >> copy [
	^ self
]

{ #category : #copying }
LbTerm >> deepCopy [
	^ self
]

{ #category : #testing }
LbTerm >> evaluateEqualityTerm [
	^ nil
]

{ #category : #inspecting }
LbTerm >> gtSortFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort';
		priority: 1;
		object: [ self sort ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LbTerm >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Term' lbCode: [ :each |
			each synopsis ];
		column: 'Sort' lbCode: [ :each |
			each sort asLeibnizSyntaxString ];
		children: #arguments;
		expandAll;
		yourself
]

{ #category : #private }
LbTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LbTerm >> hasVariables [
	self subclassResponsibility
]

{ #category : #classifying }
LbTerm >> headOpName [
	"The name of the head operator, which is used as a first heuristic in matching."
	self subclassResponsibility
]

{ #category : #comparing }
LbTerm >> isEquivalentTo: aTerm [
	"Compares two patterns and returns true if they are equal modulo
	 variable renaming."
	| vars |
	vars := self unifyTagged: #left with: aTerm tagged: #right.
	"The unification of two equivalent patterns results in their variables
	 being paired up. So: no bindings, unbound sets of size 2 with one variable
	 from each term, which have the same sorts."
	vars ifFailure: [ ^ false ].
	vars hasNoBindings ifFalse: [ ^ false ].
	vars unboundVarSets do: [ :each |
		each size = 2 ifFalse: [ ^ false ].
		(each collect: [ :v | vars sortOf: v ])
			size = 1 ifFalse: [ ^ false ]  ].
	^ true
]

{ #category : #testing }
LbTerm >> isInfix [
	"Answer true if the term is printed in infix notation."
	^ false.
]

{ #category : #comparing }
LbTerm >> isRestrictionOf: aTerm [
	"Compares two patterns and returns true if the set of terms matching the
	 receiver is a subset of the terms matching the argument."
	| vars |
	"Unification finds the intersection of the two sets of matching terms."
	vars := self unifyTagged: #left with: aTerm tagged: #right.
	vars ifFailure: [ ^ false ].
	"It's OK to have bound variables in #right, but not in #left, as that would
	 imply a restriction of the matching set."
	vars bindings associationsDo: [ :each |
		each key tag = #left ifTrue: [ ^ false ] ].
	"In each set of equal-but-unbound variables, there can be at most one
	 variable tagged #left, otherwise there would be a restriction. The
	 sort of the set must be equal to the sort of the variable tagged #left."
	vars unboundVarSets do: [ :each |
		| left |
		left := each select: [ :v | v tag = #left ].
		left size > 1 ifTrue: [ ^ false ].
		left ifNotEmpty: [ (vars sortOf: left anyOne) = (vars sortOf: each)
								ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #testing }
LbTerm >> isTrue [
	"Answer true if the term the truth value 'true'."
	^ false.
]

{ #category : #testing }
LbTerm >> isVariable [
	^ false
]

{ #category : #matching }
LbTerm >> match: otherTerm [
	| variables |
	variables := LbVariables new.
	self match: otherTerm variables: variables.
	^ variables
]

{ #category : #matching }
LbTerm >> match: otherTerm variables: variables [
	self = otherTerm
		ifFalse: [ variables failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #matching }
LbTerm >> matchVar: aSymbol ofSort: aSort variables: anLbVariables [
	self
		assert: self hasVariables not
		description: 'Variable(s) in term being matched to'.
	anLbVariables bindVar: aSymbol ofSort: aSort to: self
]

{ #category : #printing }
LbTerm >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self printAsLeibnizSyntaxOn: aStream parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #printing }
LbTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $(. ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $). ].
]

{ #category : #printing }
LbTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LbTerm >> signature [
	^signature
]

{ #category : #accessing }
LbTerm >> sort [
	^self subclassResponsibility
]

{ #category : #substituting }
LbTerm >> substitute: aSubstitution [
	^ self
]

{ #category : #inspecting }
LbTerm >> synopsis [
	"The text shown in a tree view. This is the full term except for LbOpTerms"
	^ self asLeibnizSyntaxString
]

{ #category : #matching }
LbTerm >> unify: otherTerm [
	| variables |
	variables := LbVariables new.
	self unify: otherTerm variables: variables.
	^ variables
]

{ #category : #matching }
LbTerm >> unify: otherTerm variables: variables [
	self
		unifyTagged: nil
		with: otherTerm
		tagged: nil
		variables: variables
]

{ #category : #matching }
LbTerm >> unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol [
	| variables |
	variables := LbVariables new.
	self unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol variables: variables.
	^ variables
]

{ #category : #matching }
LbTerm >> unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol variables: variables [
	self subclassResponsibility
]

{ #category : #matching }
LbTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: anotherSymbol op: anOpName args: anArgList variables: variables [
	variables failWith: self notUnifiableWith: otherTerm
]

{ #category : #matching }
LbTerm >> unifyTagged: aSymbol withVar: aTaggedName sort: aSort variables: variables [
	variables bindVar: aTaggedName ofSort: aSort to: self.
	self variables associationsDo: [ :each |
		| taggedName |
		taggedName := LbTaggedVariableName tag: aSymbol name: each key.
		variables defineVar: taggedName sort: each value ]
]

{ #category : #accessing }
LbTerm >> variables [
	self subclassResponsibility
]

{ #category : #transforming }
LbTerm >> withTransformedArgs: anArgList [
	self assert: anArgList size equals: 0.
	^ self
]
