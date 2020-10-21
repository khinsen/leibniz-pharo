Class {
	#name : #LbSignatureExamples,
	#superclass : #LbSortGraphExamples,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #example }
LbSignatureExamples >> arityA [
	<gtExample>
	^ self arityForArgSorts: #(#A)
]

{ #category : #example }
LbSignatureExamples >> arityAB [
	<gtExample>
	^ self arityForArgSorts: #(#A #B)
]

{ #category : #example }
LbSignatureExamples >> arityB [
	<gtExample>
	| arity |
	arity := self arityForArgSorts: #(#B).
	self assert: (arity <= arity).
	self assert: (self arityA <= arity).
	^ arity
]

{ #category : #example }
LbSignatureExamples >> arityDC [
	<gtExample>
	| arity |
	arity := self arityForArgSorts: #(#D #C).
	self assert: (arity <= arity).
	self assert: (self arityAB <= arity).
	^ arity
]

{ #category : #support }
LbSignatureExamples >> arityForArgSorts: argSorts [
	| sortGraph |
	sortGraph := self sortGraphABCD.
	^ LbArity
		sortGraph: sortGraph
		argSorts: (argSorts collect: [ :each | sortGraph sortNamed: each ])
]

{ #category : #example }
LbSignatureExamples >> arityKindOfA [
	<gtExample>
	^ self arityA liftToKindLevel
]

{ #category : #example }
LbSignatureExamples >> emptyArity [
	<gtExample>
	| sortGraph |
	sortGraph := self sortGraphABCD.
	^ LbArity
		sortGraph: sortGraph
		argSorts: Array new
]

{ #category : #example }
LbSignatureExamples >> infixOpFoo [
	<gtExample>
	| opName |
	opName := LbInfixOperatorName for: #foo.
	self assert: opName internalSymbol equals: #'_foo'.
	self assert: opName equals: (LbOperatorName fromInternalSymbol: #'_foo').
	^ opName
]

{ #category : #example }
LbSignatureExamples >> nonMonotonicOpInSignatureBuilder [
	<gtExample>
	| builder |
	builder := LbSignatureBuilder sortGraph: self sortGraphABCD.
	builder parseAndAddOp: 'foo(A) : B'.
	self should: [ builder parseAndAddOp: 'foo(B) : A' ]
		  raise: Error.
	^ builder
]

{ #category : #example }
LbSignatureExamples >> opFooOfA [
	<gtExample>
	| signature argSorts op |
	signature := self signatureFooBar.
	argSorts := { signature sortGraph sortNamed: #A }.
	op := signature opNamed: (self prefixOpFoo) withArgs: argSorts.
	self assert: (op ranksMatchingArgSorts: argSorts) size equals: 4.
	self assert: (op ranksMatchingArgSorts: { signature sortGraph sortNamed: #B }) size equals: 2.
	self assert: (op ranksMatchingArgSorts: { signature sortGraph sortNamed: #C }) size equals: 1.
	self assert: (op ranksMatchingArgSorts: { signature sortGraph sortNamed: #D }) size equals: 1.
	self assert: (op sortForArgSorts: argSorts) name equals: #A.
	self assert: (op sortForArgSorts: { signature sortGraph sortNamed: #B }) name equals: #B.
	self assert: (op sortForArgSorts: { signature sortGraph sortNamed: #C }) name equals: #C.
	self assert: (op sortForArgSorts: { signature sortGraph sortNamed: #D }) name equals: #D.
	^ op
]

{ #category : #example }
LbSignatureExamples >> opVarConflictInSignatureBuilder [
	<gtExample>
	| b |
	b := LbSignatureBuilder sortGraph: self sortGraphABCD.
	b addOp: #foo ofSort: #A.
	b addVar: #bar ofSort: #A.
	self should: [ b addVar: #foo ofSort: #A ] raise: Error.
	self should: [ b addOp: #bar ofSort: #A ] raise: Error.
	^ b
]

{ #category : #example }
LbSignatureExamples >> prefixOpFoo [
	<gtExample>
	| opName |
	opName := LbPrefixOperatorName for: #foo.
	self assert: opName internalSymbol equals: #foo.
	^ opName
]

{ #category : #example }
LbSignatureExamples >> signatureFooBar [
	<gtExample>
	| builder signature |
	builder := LbSignatureBuilder sortGraph: self sortGraphABCD.
	builder parseAndAddOp: 'foo : A'.
	builder parseAndAddOp: 'foo(bar:A) : A'.
	builder parseAndAddOp: 'foo(B) : B'.
	builder parseAndAddOp: 'foo(C) : C'.
	builder parseAndAddOp: 'foo(D) : D'.
	builder parseAndAddOp: 'A + A : A'.
	builder parseAndAddOp: 'A[A, A] : A'.
	builder parseAndAddOp: 'A_{A} : A'.
	builder parseAndAddOp: 'A^{A} : A'.
	signature := builder signature.
	self assert: signature equals: (self signatureFooBarExplicit).
	^ signature
]

{ #category : #example }
LbSignatureExamples >> signatureFooBarExplicit [
	<gtExample>
	| builder |
	builder := LbSignatureBuilder sortGraph: self sortGraphABCD.
	builder addOp: #foo asLbOperatorName ofSort: #A.
	builder addVar: #bar asLbOperatorName ofSort: #A.
	builder addOp: #foo asLbOperatorName withArgs: #(#A) ofSort: #A.
	builder addOp: #foo asLbOperatorName withArgs: #(#B) ofSort: #B.
	builder addOp: #foo asLbOperatorName withArgs: #(#C) ofSort: #C.
	builder addOp: #foo asLbOperatorName withArgs: #(#D) ofSort: #D.
	builder addOp: (LbInfixOperatorName for: '+')
			withArgs: #(#A #A)  ofSort: #A.
	builder addOp: (LbBracketOperatorName new)
			withArgs: #(#A #A #A)  ofSort: #A.
	builder addOp: (LbSubscriptOperatorName new)
			withArgs: #(#A #A)  ofSort: #A.
	builder addOp: (LbSuperscriptOperatorName new)
			withArgs: #(#A #A)  ofSort: #A.
	^ builder signature
]

{ #category : #example }
LbSignatureExamples >> sortConflictInSignatureBuilder [
	<gtExample>
	| b |
	b := LbSignatureBuilder sortGraph: self sortGraphABCD.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	b addVar: #bar ofSort: #A.
	self should: [ b addOp: #foo withArgs: #(#A) ofSort: #B ] raise: Error.
	self should: [ b addVar: #bar ofSort: #B ] raise: Error.
	^ b
]
