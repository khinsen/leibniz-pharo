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

{ #category : #converting }
LzTerm >> addAsFirstArgOfInfixTermWithOpName: anOpName asRopedTextTo: aRopedText [
	self
		addAsRopedTextTo: aRopedText
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #unifying }
LzTerm >> addPrefix: aSymbol toVarsConflictingWith: anotherTerm [
	| bindings myVars otherVars |
	myVars := self vars.
	otherVars := anotherTerm vars.
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
	(myVars keys intersection: otherVars keys)
		ifNotEmpty: [ :conflicts |
			conflicts do: [ :each |
				| newName sort |
				[
					newName := each addPrefix: aSymbol.
					otherVars includes: newName
				] whileTrue.
				sort := myVars at: each.
				bindings defineVar: each sort: sort.
				bindings
					bindVar: each
					sort: sort
					to: (LzVarTerm new
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

{ #category : #rewriting }
LzTerm >> ensureArrayTerm [
	LzRewriteFailure signal: 'not an array term'
]

{ #category : #rewriting }
LzTerm >> ensureNumber [
	LzRewriteFailure signal: 'not a number term'
]

{ #category : #rewriting }
LzTerm >> ensureString [
	LzRewriteFailure signal: 'not a number term'
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

{ #category : #inspecting }
LzTerm >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Term' text: [ :each |
			each synopsis asRopedText
				fontName: LzCodeFont defaultFamily ];
		column: 'Sort' text: [ :each |
			each sort asLeibnizSyntax ];
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
LzTerm >> isLeafErrorTerm [
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
		(each select: [ :v | v tag = #left ]) ifNotEmpty: [ :left | 
			left size > 1 ifTrue: [ ^ false ].
			(vars sortOf: left anyOne) = (vars restrictedSortOf: left anyOne)
				ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #rewriting }
LzTerm >> isSyntacticallyEqualTo: otherTerm [
	^ LzBooleanTerm
		signature: self signature
		value: (self = otherTerm)
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
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
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
	self flag: #todo. "Obsolete? Allowing vars in standard match operations is simpler."
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
LzTerm >> matchArrayENode: anOpENode  bindings: bindings [
	self subclassResponsibility
]

{ #category : #egraphs }
LzTerm >> matchOpENode: anOpENode  bindings: bindings [
	self subclassResponsibility
]

{ #category : #unifying }
LzTerm >> matchVar: aSymbol sort: aSort bindings: bindings [
	self flag: #todo. "Should vars be allowed in bound values?"
	"self
		assert: self hasVars not
		description: 'Term being matched to has variables'."
	bindings bindVar: aSymbol sort: aSort to: self
]

{ #category : #rewriting }
LzTerm >> normalFormIn: aContext [
	^ aContext reduce: self
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
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
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
	bindings := LzBindings new
					sortGraph: self signature sortGraph.
	self unifyTagged: aSymbol with: otherTerm tagged: anotherSymbol bindings: bindings.
	^ bindings
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	self subclassResponsibility
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: anotherSymbol op: anOpName args: anArgList bindings: bindings [
	bindings failWith: self notUnifiableWith: otherTerm
]

{ #category : #unifying }
LzTerm >> unifyTagged: aSymbol withVar: aTaggedName sort: aSort bindings: bindings [
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
