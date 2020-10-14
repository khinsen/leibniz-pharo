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
	signature := builder signature.
	self assert: signature equals: (self signatureFooBarExplicit).
	^ signature
]

{ #category : #example }
LbSignatureExamples >> signatureFooBarExplicit [
	<gtExample>
	| builder |
	builder := LbSignatureBuilder sortGraph: self sortGraphABCD.
	builder addOp: #foo ofSort: #A.
	builder addVar: #bar ofSort: #A.
	builder addOp: #foo withArgs: #(#A) ofSort: #A.
	builder addOp: #'_+' withArgs:#(#A #A)  ofSort: #A.
	^ builder signature.
]
