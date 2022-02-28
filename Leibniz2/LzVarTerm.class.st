Class {
	#name : #LzVarTerm,
	#superclass : #LzTerm,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Terms'
}

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
	bindings defineVar: name sort: sort.
	otherTerm matchVar: name sort: sort bindings: bindings
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
	aStream nextPutAll: name asSymbol
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
	| taggedName |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	bindings defineVar: taggedName sort: sort.
	otherTerm unifyTagged: otherSymbol withVar: taggedName sort: sort bindings: bindings
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
	| taggedName |
	taggedName := LzTaggedVarName tag: aSymbol name: name.
	bindings defineVar: taggedName sort: sort.
	bindings
		makeVar: taggedName
		sort: sort
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
