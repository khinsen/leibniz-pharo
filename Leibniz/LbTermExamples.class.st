Class {
	#name : #LbTermExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-3-Terms'
}

{ #category : #example }
LbTermExamples >> booleanTerm [
	<gtExample>
	| t |
	t := LbBuiltinSignatures truthSignature zeroArgTermNamed: (LbPrefixOperatorName for: #true).
	self assert: t sort name equals: #boolean.
	^ t
]

{ #category : #example }
LbTermExamples >> integerTerms [
	<gtExample>
	| inputs |
	inputs := {
		2 -> #'ℕ.nz'.
		0 -> #zero.
		-2 -> #'ℤ.nz'.
	}.
	^ inputs collect: [ :each |
		| t |
		t := LbBuiltinSignatures integerSignature atomicTerm: each key.
		self assert: t sort name equals: each value.
		t ]
]

{ #category : #example }
LbTermExamples >> parserForFooBar [
	<gtExample>
	| signature |
	signature := LbSignatureExamples new signatureFooBar.
	^ LbTermParser forSignature: signature
]

{ #category : #example }
LbTermExamples >> signatureForTermParserTests [
	<gtExample>
	| sortGraph |
	sortGraph := LbSortGraphBuilder new
		parseAndAdd: 'A';
		parseAndAdd: 'B ⊆ A';
		parseAndAdd: 'boolean';
		sortGraph.
	^ (LbSignatureBuilder sortGraph: sortGraph)
		addBuiltin: #integers;
		addBuiltin: #rationalNumbers;
		addBuiltin: #fpNumbers;
		addBuiltin: #strings;
		parseAndAddVar: 'aVar:A';
		parseAndAddOp: 'aZeroArgOp : B';
		parseAndAddOp: 'aOneArgOp(A) : A';
		parseAndAddOp: 'aOneArgOp(B) : B';
		parseAndAddOp: 'aTwoArgOp(A, A) : A';
		parseAndAddOp: 'A[A] : A';
		parseAndAddOp: 'A^{A} : A';
		parseAndAddOp: 'A^{A,A} : A';
		parseAndAddOp: 'A_{A} : A';
		parseAndAddOp: 'A_{A,A} : A';
		parseAndAddOp: 'A infixOp1 A : A';
		parseAndAddOp: 'A infixOp2 A : A';
		parseAndAddOp: 'true : boolean';
		parseAndAddOp: 'false : boolean';
		signature
]

{ #category : #example }
LbTermExamples >> stringTerm [
	<gtExample>
	| t |
	t := LbBuiltinSignatures stringSignature atomicTerm: 'abc'.
	self assert: t sort name equals: #string.
	^ t
]

{ #category : #example }
LbTermExamples >> termFoo [
	<gtExample>
	^ self parserForFooBar parse: 'foo'
]

{ #category : #example }
LbTermExamples >> termFooBracketFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: LbBracketOperatorName new
		args: { self termFooExplicit. self termFooOfFoo }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooExplicit [
	<gtExample>
	| signature sortGraph |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	^ LbOpTerm
		symbol: (LbPrefixOperatorName for: #foo)
		args: #()
		sort: (sortGraph sortNamed: #A)
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: (LbPrefixOperatorName for: #foo)
		args: { self termFooExplicit }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooPlusFooExplicit [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		symbol: (LbInfixOperatorName for: #+)
		args: { self termFooExplicit. self termFooExplicit }
		sort: sortA
		forSignature: signature
]
