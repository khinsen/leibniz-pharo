Class {
	#name : #LbSignatureExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
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
	sortGraph := LbSortGraphExamples new sortGraphABCD.
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
LbSignatureExamples >> booleanSignature [
	<gtExample>
	^ ((LbSignatureBuilder sortGraph: LbBuiltinSortGraphs truthSortGraph)
		addSignature: (LbBuiltinSignatures truthSignature) includeVars: false)
		parseAndAddOp: '¬(boolean) : boolean';
		parseAndAddOp: 'boolean ∧ boolean : boolean';
		parseAndAddOp: 'boolean ∨ boolean : boolean';
		parseAndAddOp: 'boolean ⊻ boolean : boolean';
		parseAndAddVar: 'X:boolean';
		parseAndAddVar: 'Y:boolean';
		signature
]

{ #category : #example }
LbSignatureExamples >> emptyArity [
	<gtExample>
	| sortGraph |
	sortGraph := LbSortGraphExamples new sortGraphABCD.
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
	builder := LbSignatureBuilder sortGraph: LbSortGraphExamples new sortGraphABCD.
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
	argSorts := { signature sortNamed: #A }.
	op := signature opNamed: (self prefixOpFoo) withArgs: argSorts.
	self assert: (op ranksMatchingArgSorts: argSorts) size equals: 4.
	self assert: (op ranksMatchingArgSorts: { signature sortNamed: #B }) size equals: 2.
	self assert: (op ranksMatchingArgSorts: { signature sortNamed: #C }) size equals: 1.
	self assert: (op ranksMatchingArgSorts: { signature sortNamed: #D }) size equals: 1.
	self assert: (op sortForArgSorts: argSorts) name equals: #A.
	self assert: (op sortForArgSorts: { signature sortNamed: #B }) name equals: #B.
	self assert: (op sortForArgSorts: { signature sortNamed: #C }) name equals: #C.
	self assert: (op sortForArgSorts: { signature sortNamed: #D }) name equals: #D.
	^ op
]

{ #category : #example }
LbSignatureExamples >> opVarConflictInSignatureBuilder [
	<gtExample>
	| builder |
	builder := LbSignatureBuilder sortGraph: LbSortGraphExamples new sortGraphABCD.
	builder parseAndAddOp: 'foo : A'.
	builder parseAndAddVar: 'bar:A'.
	self should: [ builder builder parseAndAddVar: 'foo:A' ] raise: Error.
	self should: [ builder parseAndAddOp: 'bar : A' ] raise: Error.
	^ builder
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
	builder := LbSignatureBuilder sortGraph: LbSortGraphExamples new sortGraphABCD.
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
	self assert: (signature opsOfKind: (signature sortNamed: #A) kind) size equals: 6.
	^ signature
]

{ #category : #example }
LbSignatureExamples >> signatureFooBarExplicit [
	<gtExample>
	| builder sortGraph sortA sortB sortC sortD |
	sortGraph := LbSortGraphExamples new sortGraphABCD.
	builder := LbSignatureBuilder sortGraph: sortGraph.
	sortA := sortGraph sortNamed: #A.
	sortB := sortGraph sortNamed: #B.
	sortC := sortGraph sortNamed: #C.
	sortD := sortGraph sortNamed: #D.
	builder addOp: #foo asLbOperatorName ofSort: sortA.
	builder addVar: #bar asLbOperatorName ofSort: sortA.
	builder addOp: #foo asLbOperatorName withArgs: { sortA } ofSort: sortA.
	builder addOp: #foo asLbOperatorName withArgs: { sortB } ofSort: sortB.
	builder addOp: #foo asLbOperatorName withArgs: { sortC } ofSort: sortC.
	builder addOp: #foo asLbOperatorName withArgs: { sortD }ofSort: sortD.
	builder
		addOp: (LbInfixOperatorName for: '+')
		withArgs: { sortA. sortA }
		ofSort: sortA.
	builder
		addOp: LbBracketOperatorName new
		withArgs: { sortA. sortA. sortA }
		ofSort: sortA.
	builder
		addOp: LbSubscriptOperatorName new
		withArgs: { sortA. sortA }
		ofSort: sortA.
	builder
		addOp: LbSuperscriptOperatorName new
		withArgs: { sortA. sortA }
		ofSort: sortA.
	^ builder signature
]

{ #category : #example }
LbSignatureExamples >> sortConflictInSignatureBuilder [
	<gtExample>
	| builder |
	builder := LbSignatureBuilder sortGraph: LbSortGraphExamples new sortGraphABCD.
	builder parseAndAddOp: 'foo(A) : A'.
	builder parseAndAddVar: 'bar:A'.
	self should: [ builder parseAndAddOp: 'foo(A) : B' ]
		 raise: Error.
	self should: [ builder parseAndAddVar: 'bar:B' ]
		 raise: Error.
	^ builder
]
