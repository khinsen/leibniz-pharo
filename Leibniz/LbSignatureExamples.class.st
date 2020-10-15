Class {
	#name : #LbSignatureExamples,
	#superclass : #LbSortGraphExamples,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #example }
LbSignatureExamples >> arityA [
	<gtExample>
	| sortGraph |
	sortGraph := self sortGraphABCD.
	^ LbArity
		sortGraph: sortGraph
		argSorts: { (sortGraph sortNamed: #A) }
]

{ #category : #example }
LbSignatureExamples >> arityKindOfA [
	<gtExample>
	^ self arityA liftToKindLevel
]

{ #category : #accessing }
LbSignatureExamples >> emptyArity [
	<gtExample>
	| sortGraph |
	sortGraph := self sortGraphABCD.
	^ LbArity
		sortGraph: sortGraph
		argSorts: Array new
]

{ #category : #example }
LbSignatureExamples >> signatureFooBar [
	<gtExample>
	| builder signature |
	builder := LbSignatureBuilder sortGraph: self sortGraphABCD.
	builder parseAndAddOp: 'foo : A'.
	builder parseAndAddOp: 'foo(bar:A) : A'.
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
