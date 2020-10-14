Class {
	#name : #LbSignatureParser,
	#superclass : #LbSignatureGrammar,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #productions }
LbSignatureParser >> bracketOp [
	^ super bracketOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes third reject: [ :element | element = $,]).
				{ #'[]'. args asArray } ]
]

{ #category : #productions }
LbSignatureParser >> infixOp [
	^ super infixOp
		==> [ :nodes | { ('_', nodes second) asSymbol. { nodes first. nodes third } } ]

]

{ #category : #productions }
LbSignatureParser >> op [
	^ super op
		==> [ :nodes | { nodes first. nodes third first } ]

]

{ #category : #productions }
LbSignatureParser >> prefixOp [
	^ super prefixOp
		==> [ :nodes | { nodes first asSymbol. nodes third reject: [ :element | element = $,] } ]
]

{ #category : #productions }
LbSignatureParser >> sort [
	^ super sort
		==> [ :id | { id } ]

]

{ #category : #productions }
LbSignatureParser >> subscriptOp [
	^ super subscriptOp
		==> [ :nodes | { #'_'. { nodes first. nodes fourth } } ]

]

{ #category : #productions }
LbSignatureParser >> superscriptOp [
	^ super superscriptOp
		==> [ :nodes | { #'^'. { nodes first. nodes fourth } } ]

]

{ #category : #productions }
LbSignatureParser >> var [
	^ super var
		==> [ :nodes | { nodes first. nodes third } ]

]

{ #category : #productions }
LbSignatureParser >> zeroArgOp [
	^ super zeroArgOp
		==> [ :idString | { idString asSymbol. #() } ]
]
