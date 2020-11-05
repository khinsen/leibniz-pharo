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
				{ LbBracketOperatorName new. args asArray } ]
]

{ #category : #productions }
LbSignatureParser >> infixOp [
	^ super infixOp
		==> [ :nodes | { LbInfixOperatorName for: nodes second. { nodes first. nodes third } } ]

]

{ #category : #productions }
LbSignatureParser >> op [
	^ super op
		==> [ :nodes | { nodes first. nodes third first } ]

]

{ #category : #productions }
LbSignatureParser >> prefixOp [
	^ super prefixOp
		==> [ :nodes | { LbPrefixOperatorName for: nodes first. nodes third reject: [ :element | element = $,] } ]
]

{ #category : #productions }
LbSignatureParser >> sort [
	^ super sort
		==> [ :id | { id } ]

]

{ #category : #productions }
LbSignatureParser >> subscriptOp [
	^ super subscriptOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes fourth reject: [ :element | element = $,]).
				{ LbSubscriptOperatorName new. args asArray } ]
]

{ #category : #productions }
LbSignatureParser >> superscriptOp [
	^ super superscriptOp
		==> [ :nodes |
				| args |
				args := OrderedCollection with: nodes first.
				args addAll: (nodes fourth reject: [ :element | element = $,]).
				{ LbSuperscriptOperatorName new. args asArray } ]
]

{ #category : #productions }
LbSignatureParser >> var [
	^ super var
		==> [ :nodes | { nodes first. nodes third } ]

]

{ #category : #productions }
LbSignatureParser >> zeroArgOp [
	^ super zeroArgOp
		==> [ :idString | { LbPrefixOperatorName for: idString. #() } ]
]
