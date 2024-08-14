Class {
	#name : #LzVarTerm,
	#superclass : #LzTerm,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #converting }
LzVarTerm >> addAsRopedTextTo: aRopedText [
	name addAsRopedTextTo: aRopedText
]

{ #category : #egraphs }
LzVarTerm >> asENodeIn: anEGraph [
	self shouldNotImplement
]

{ #category : #organizing }
LzVarTerm >> fingerprint [
	^ #var
]

{ #category : #testing }
LzVarTerm >> hasVars [
	^ true
]

{ #category : #testing }
LzVarTerm >> isVarTerm [
	^ true
]

{ #category : #unifying }
LzVarTerm >> match: otherTerm bindings: bindings [
	| sortBindings matchedSort |
	sortBindings := self sort matchWithSupersortsOf: otherTerm sort.
	sortBindings
		ifSuccess: [
			matchedSort := sort substitute: sortBindings.
			bindings combineWith: sortBindings ]
		ifFailure: [ matchedSort := sort ].
	bindings defineVar: name sort: matchedSort.
	otherTerm matchVar: name sort: matchedSort bindings: bindings
]

{ #category : #egraphs }
LzVarTerm >> matchArrayENode: anArrayENode  bindings: bindings [
	bindings defineVar: self name sort: self sort.
	^ Generator on: [ :generator |
		anArrayENode allTerms do: [ :each |
			| b |
			b := bindings copy.
			b bindVar: self name sort: self sort to: each.
			b ifSuccess: [ generator yield: b ] ] ]
]

{ #category : #unifying }
LzVarTerm >> matchArrayTerm: otherTerm elements: aTermList bindings: bindings [
	self error: 'Variable in term being matched to'
]

{ #category : #egraphs }
LzVarTerm >> matchOpENode: anOpENode  bindings: bindings [
	bindings defineVar: self name sort: self sort.
	^ Generator on: [ :generator |
		anOpENode allTerms do: [ :each |
			| b |
			b := bindings copy.
			b bindVar: self name sort: self sort to: each.
			b ifSuccess: [ generator yield: b ] ] ]
]

{ #category : #unifying }
LzVarTerm >> matchOpTerm: otherTerm op: anOpName args: anArgList bindings: bindings [
	self error: 'Variable in term being matched to'
]

{ #category : #accessing }
LzVarTerm >> name [
	^ name
]

{ #category : #accessing }
LzVarTerm >> name: aVarName [
	name := aVarName
]

{ #category : #printing }
LzVarTerm >> printAsLeibnizSyntaxOn: aStream [
	name printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzVarTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzVarTerm >> sort: aSort [
	sort := aSort
]

{ #category : #unifying }
LzVarTerm >> substitute: bindings [
	(bindings bindingFor: name) ifNotNil: [ :value | ^ value ].
	^ self
]

{ #category : #unifying }
LzVarTerm >> unifyTagged: aSymbol with: otherTerm tagged: otherSymbol bindings: bindings [
	| taggedName sortBindings matchedSort |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	sortBindings :=
		sort term
			unifyTagged: aSymbol
			with: otherTerm sort term
			tagged: otherSymbol.
	sortBindings
		ifSuccess: [
			matchedSort := sort sortGraph sortWithTerm:
					(sort term substitute: sortBindings).
			bindings combineWith: sortBindings ]
		ifFailure: [ matchedSort := sort ].
	bindings defineVar: taggedName sort: matchedSort.
	otherTerm
		unifyTagged: otherSymbol
		withVar: taggedName
		sort: matchedSort
		bindings: bindings
]

{ #category : #unifying }
LzVarTerm >> unifyTagged: aSymbol withArrayTerm: otherTerm tagged: otherSymbol elements: aTermList shape: anArray bindings: bindings [
	| taggedName |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	bindings defineVar: taggedName sort: sort.
	otherTerm
		unifyTagged: otherSymbol
		withVar: taggedName
		sort: sort
		bindings: bindings
]

{ #category : #unifying }
LzVarTerm >> unifyTagged: aSymbol withAtomicTerm: otherTerm tagged: otherSymbol bindings: bindings [
	| taggedName |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	bindings defineVar: taggedName sort: sort.
	otherTerm unifyTagged: otherSymbol withVar: taggedName sort: sort bindings: bindings
]

{ #category : #unifying }
LzVarTerm >> unifyTagged: aSymbol withOpTerm: otherTerm tagged: otherSymbol op: anOpName args: anArgList bindings: bindings [
	| taggedName |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	bindings defineVar: taggedName sort: sort.
	otherTerm
		unifyTagged: otherSymbol
		withVar: taggedName
		sort: sort
		bindings: bindings
]

{ #category : #unifying }
LzVarTerm >> unifyTagged: aSymbol withVar: aTaggedName sort: aSort bindings: bindings [
	| taggedName matchedSort |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	"When we get here, the unification of the sorts of the two
	 vars has already been done, as has the substitution in
	 aSort."
	matchedSort := sort sortGraph sortWithTerm:
					(sort term substitute: bindings).
	bindings defineVar: taggedName sort: matchedSort.
	bindings
		makeVar: taggedName
		sort: matchedSort
		equalToVar: aTaggedName
		sort: aSort
]

{ #category : #accessing }
LzVarTerm >> valueSlots [
	^ #(name sort)
]

{ #category : #accessing }
LzVarTerm >> vars [
	^ Dictionary with: name -> sort
]
