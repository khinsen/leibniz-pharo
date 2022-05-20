Trait {
	#name : #TLzParseTreeNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitArrayElements: anArrayElements [
	^ self visitParseTree: anArrayElements
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitArrayTerm: anArrayTerm [
	^ self visitTerm: anArrayTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitBracketOpTerm: aBracketOpTerm [
	^ self visitTerm: aBracketOpTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitFpNumberLiteralTerm: aFpNumberLiteralTerm [
	^ self visitLiteralTerm: aFpNumberLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitInfixOpTerm: anInfixOpTerm [
	^ self visitParseTree: anInfixOpTerm
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
TLzParseTreeNodeVisitor >> visitPrefixOpTerm: aPrefixOpTerm [
	^ self visitTerm: aPrefixOpTerm
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
TLzParseTreeNodeVisitor >> visitSubscriptOpTerm: aSubscriptOpTerm [
	^ self visitTerm: aSubscriptOpTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitSuperscriptOpTerm: aSuperscriptOpTerm [
	^ self visitTerm: aSuperscriptOpTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTerm: aTerm [
	^ self visitParseTree: aTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelTerm: aTopLevelTerm [
	^ self visitParseTree: aTopLevelTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTerm: aVarTerm [
	^ self visitTerm: aVarTerm
]
