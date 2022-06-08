Class {
	#name : #LeibnizParserTest,
	#superclass : #PP2CompositeNodeTest,
	#category : 'Leibniz-3-Terms'
}

{ #category : #'term construction' }
LeibnizParserTest >> fpNumberTerm: aFloat [
	^ LbFPNumberTerm value: aFloat signature: parser signature
]

{ #category : #'term construction' }
LeibnizParserTest >> integerTerm: anInteger [
	^ LbIntegerTerm value: anInteger signature: parser signature
]

{ #category : #'term construction' }
LeibnizParserTest >> rationalNumberTerm: aFraction [
	^ LbRationalNumberTerm value: aFraction signature: parser signature
]

{ #category : #running }
LeibnizParserTest >> setUp [
	| b sg |
	super setUp.

	b := LbSortGraphBuilder new.
	b parseAndAdd: 'A';
	  parseAndAdd: 'B ⊆ A'.
	b parseAndAdd: 'boolean'.
	sg := b sortGraph.

	b := LbSignatureBuilder sortGraph: sg.
	b addBuiltin: #integers.
	b addBuiltin: #rationalNumbers.
	b addBuiltin: #fpNumbers.
	b addBuiltin: #strings.
	b parseAndAddVar: 'aVar:A'.
	b parseAndAddOp: 'aZeroArgOp : B'.
	b parseAndAddOp: 'aOneArgOp(A) : A'.
	b parseAndAddOp: 'aOneArgOp(B) : B'.
	b parseAndAddOp: 'aTwoArgOp(A, A) : A'.
	b parseAndAddOp: 'A[A] : A'.
	b parseAndAddOp: 'A^{A} : A'.
	b parseAndAddOp: 'A^{A, A} : A'.
	b parseAndAddOp: 'A_{A} : A'.
	b parseAndAddOp: 'A_{A, A} : A'.
	b parseAndAddOp: 'A infixOp1 A : A'.
	b parseAndAddOp: 'A infixOp2 A : A'.
	b parseAndAddOp: 'true : boolean'.
	b parseAndAddOp: 'false : boolean'.
	parser signature: b signature.
]

{ #category : #'term construction' }
LeibnizParserTest >> stringTerm: aString [
	^ LbStringTerm value: aString signature: parser signature
]
