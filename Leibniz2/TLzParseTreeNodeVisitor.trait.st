Trait {
	#name : #TLzParseTreeNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitFpNumberLiteralTerm: aFpNumberLiteralTerm [
	^ self visitLiteralTerm: aFpNumberLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitIntegerLiteralTerm: anIntegerLiteralTerm [
	^ self visitLiteralTerm: anIntegerLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitLiteralTerm: aLiteralTerm [
	^ self visitTerm: aLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitParseTree: aParseTree [
	^ self visitSmaCCParseNode: aParseTree
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitRationalNumberLiteralTerm: aRationalNumberLiteralTerm [
	^ self visitLiteralTerm: aRationalNumberLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitStringLiteralTerm: aStringLiteralTerm [
	^ self visitLiteralTerm: aStringLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTerm: aTerm [
	^ self visitParseTree: aTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTerm: aVarTerm [
	^ self visitTerm: aVarTerm
]
