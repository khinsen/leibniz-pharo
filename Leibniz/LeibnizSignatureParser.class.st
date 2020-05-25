Class {
	#name : #LeibnizSignatureParser,
	#superclass : #LeibnizSignatureGrammar,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #productions }
LeibnizSignatureParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ #'[]'. args asArray } ]
]

{ #category : #productions }
LeibnizSignatureParser >> infixOp [
	^ super infixOp
		==> [ :nodes | { ('_', nodes second) asSymbol. { nodes first. nodes third } } ]

]

{ #category : #productions }
LeibnizSignatureParser >> op [
	^ super op
		==> [ :nodes | { nodes first. nodes third first } ]

]

{ #category : #productions }
LeibnizSignatureParser >> prefixOp [
	^ super prefixOp
		==> [ :nodes | { nodes first asSymbol. nodes third reject: [ :element | element = $,] } ]
]

{ #category : #productions }
LeibnizSignatureParser >> sort [
	^ super sort
		==> [ :id | { id } ]

]

{ #category : #productions }
LeibnizSignatureParser >> subscriptOp [
	^ super subscriptOp
		==> [ :nodes | { $_. { nodes first. nodes fourth } } ]

]

{ #category : #productions }
LeibnizSignatureParser >> superscriptOp [
	^ super superscriptOp
		==> [ :nodes | { $^. { nodes first. nodes fourth } } ]

]

{ #category : #productions }
LeibnizSignatureParser >> var [
	^ super var
		==> [ :nodes | { nodes first. nodes third } ]

]

{ #category : #productions }
LeibnizSignatureParser >> zeroArgOp [
	^ super zeroArgOp
		==> [ :idString | { idString asSymbol. #() } ]
]
