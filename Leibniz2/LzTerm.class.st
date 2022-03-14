Class {
	#name : #LzTerm,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #unifying }
LzTerm >> addPrefix: aSymbol toVarsConflictingWith: anotherTerm [
	| bindings myVars otherVars |
	myVars := self vars.
	otherVars := anotherTerm vars.
	bindings := LzBindings new.
	(myVars keys intersection: otherVars keys)
		ifNotEmpty: [ :conflicts |
			conflicts do: [ :each |
				| newName sort | [
				newName := each addPrefix: aSymbol.
				otherVars includes: newName
				] whileTrue.
				sort := myVars at: each.
				bindings defineVar: each sort: sort.
				bindings
					bindVar: each
					ofSort: sort
					to: (LzVarTerm
							signature: self signature;
							name: newName;
							sort: sort;
							beRecursivelyReadOnlyObject;
							yourself) ] ].
	^ bindings
]

{ #category : #accessing }
LzTerm >> args [
	^ #()
]

{ #category : #accessing }
LzTerm >> arity [
	^ LzArity forArgs: self args
]

{ #category : #egraphs }
LzTerm >> asENodeIn: anEGraph [
	self subclassResponsibility
]

{ #category : #organizing }
LzTerm >> fingerprint [
	self subclassResponsibility
]

{ #category : #inspecting }
LzTerm >> gtSortFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort';
		priority: 1;
		object: [ self sort ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #accessing }
LzTerm >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Term' lzCode: [ :each |
			each synopsis ];
		column: 'Sort' lzCode: [ :each |
			each sort asLeibnizSyntaxString ];
		children: #args;
		expandAll;
		yourself
]

{ #category : #printing }
LzTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzTerm >> hasVars [
	^ false
]

{ #category : #testing }
LzTerm >> isInfix [
	^ false
]

{ #category : #testing }
LzTerm >> isRestrictionOf: aTerm [
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
LzTerm >> isVarTerm [
	^ false
]

{ #category : #accessing }
LzTerm >> kind [
	^ self sort kind
]

{ #category : #unifying }
LzTerm >> match: otherTerm [
	| bindings |
	bindings := LzBindings new.
	self match: otherTerm bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> match: otherTerm bindings: bindings [
	self = otherTerm ifFalse: [
		bindings failWith: self notUnifiableWith: otherTerm ]
]

{ #category : #unifying }
LzTerm >> matchAllowingVars: otherTerm [
	| bindings |
	bindings := self unifyTagged: nil with: otherTerm tagged: #arg.
	bindings bindToUniqueVar: [ :varSet :sort |
		| name candidates |
		candidates := varSet select: [ :each | each tag = #arg ].
		candidates ifEmpty: [ nil ]
		ifNotEmpty: [
			LzVarTerm new
				signature: self signature;
				name: candidates anyOne name;
				sort: sort;
				beRecursivelyReadOnlyObject;
				yourself ] ].
	^ bindings
]

{ #category : #egraphs }
LzTerm >> matchOpENode: anOpENode  bindings: bindings [
	self subclassResponsibility
]

{ #category : #unifying }
LzTerm >> matchVar: aSymbol sort: aSort bindings: bindings [
	self
		assert: self hasVars not
		description: 'Term being matched to has variables'.
	bindings bindVar: aSymbol sort: aSort to: self
]

{ #category : #accessing }
LzTerm >> opName [
	^ nil
]

{ #category : #printing }
LzTerm >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #printing }
LzTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
LzTerm >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzTerm >> signature [
	^ signature
]

{ #category : #accessing }
LzTerm >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTerm >> sort [
	self subclassResponsibility
]

{ #category : #unifying }
LzTerm >> substitute: bindings [
	^ self
]

{ #category : #unifying }
LzTerm >> substitute: bindings tag: aSymbol [
	^ self
]

{ #category : #inspecting }
LzTerm >> synopsis [
	"The text shown in a tree view. This is the full term except for LbOpTerms"
	^ self asLeibnizSyntaxString
]

{ #category : #unifying }
LzTerm >> unify: otherTerm [
	| bindings |
	bindings := LzBindings new.
	self unify: otherTerm bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> unify: otherTerm bindings: bindings [
	self
		unifyTagged: nil
		with: otherTerm
		tagged: nil
		bindings: bindings
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol [
	| bindings |
	bindings := LzBindings new.
	self unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	self subclassResponsibility
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: anotherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol withVar: aTaggedName sort: aSort bindings: bindings [
	self sort term unifyTagged: aSymbol with: aSort term tagged: aTaggedName tag bindings: bindings.
	bindings bindVar: aTaggedName sort: aSort to: self.
	self vars associationsDo: [ :each |
		| taggedName |
		taggedName := LzTaggedVarName tag: aSymbol name: each key.
		bindings defineVar: taggedName sort: each value ]
]

{ #category : #accessing }
LzTerm >> vars [
	^ Dictionary new
]

{ #category : #transforming }
LzTerm >> withTransformedArgs: anArgList [
	self assert: anArgList size equals: 0.
	^ self
]
