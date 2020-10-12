Class {
	#name : #LeibnizParserTest,
	#superclass : #PP2CompositeNodeTest,
	#category : #'Leibniz-Tests'
}

{ #category : #'term construction' }
LeibnizParserTest >> fpNumberTerm: aFloat [
	^ LeibnizFPNumberTerm value: aFloat forSignature: parser signature
]

{ #category : #'term construction' }
LeibnizParserTest >> integerTerm: anInteger [
	^ LeibnizIntegerTerm value: anInteger forSignature: parser signature
]

{ #category : #'term construction' }
LeibnizParserTest >> rationalNumberTerm: aFraction [
	^ LeibnizRationalNumberTerm value: aFraction forSignature: parser signature
]

{ #category : #running }
LeibnizParserTest >> setUp [
	| b sg |
	super setUp.

	b := LbSortGraphBuilder new.
	b add: #A;
	  add: #B;
	  make: #B subsortOf: #A.
	b add: #boolean.
	sg := b sortGraph.

	b := LeibnizSignatureBuilder sortGraph: sg.
	b addBuiltin: #integers.
	b addBuiltin: #rationalNumbers.
	b addBuiltin: #fpNumbers.
	b addBuiltin: #strings.
	b addVar: #aVar ofSort: #A.
	b addOp: #aZeroArgOp ofSort: #B.
	b addOp: #aOneArgOp withArgs: #(#A) ofSort: #A.
	b addOp: #aOneArgOp withArgs: #(#B) ofSort: #B.
	b addOp: #aTwoArgOp withArgs: #(#A #A) ofSort: #A.
	b addOp: #'[]' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'[]' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'^' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'^' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'_' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'_' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'_infixOp1' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'_infixOp2' withArgs: #(#A #A) ofSort: #A.
	b addOp: #true ofSort: #boolean.
	b addOp: #false ofSort: #boolean.
	parser setSignature: b signature.

]

{ #category : #'term construction' }
LeibnizParserTest >> stringTerm: aString [
	^ LeibnizStringTerm value: aString forSignature: parser signature
]
