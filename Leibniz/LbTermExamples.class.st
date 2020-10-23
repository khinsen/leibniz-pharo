Class {
	#name : #LbTermExamples,
	#superclass : #LbSignatureExamples,
	#category : #'Leibniz-3-Terms'
}

{ #category : #example }
LbTermExamples >> termFoo [
	<gtExample>
	| signature sortGraph |
	signature := self signatureFooBar.
	sortGraph := signature sortGraph.
	^ LbOpTerm
		symbol: (LbPrefixOperatorName for: #foo)
		args: #()
		sort: (sortGraph sortNamed: #A)
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooBracketFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := self signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: LbBracketOperatorName new
		args: { self termFoo. self termFooOfFoo }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := self signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: (LbPrefixOperatorName for: #foo)
		args: { self termFoo }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooPlusFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := self signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: (LbInfixOperatorName for: #+)
		args: { self termFoo. self termFoo }
		sort: sortA
		forSignature: signature
]
