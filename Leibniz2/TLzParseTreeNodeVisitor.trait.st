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
TLzParseTreeNodeVisitor >> visitInfixOp: anInfixOp [
	^ self visitOp: anInfixOp
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
TLzParseTreeNodeVisitor >> visitOp: anOp [
	^ self visitParseTree: anOp
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitParseTree: aParseTree [
	^ self visitSmaCCParseNode: aParseTree
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitPrefixOp: aPrefixOp [
	^ self visitOp: aPrefixOp
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
TLzParseTreeNodeVisitor >> visitTopLevelAxiom: aTopLevelAxiom [
	^ self visitParseTree: aTopLevelAxiom
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	^ self visitTopLevelAxiom: aTopLevelEqualityAxiom
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelFunctionRule: aTopLevelFunctionRule [
	^ self visitTopLevelRule: aTopLevelFunctionRule
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelOp: aTopLevelOp [
	^ self visitParseTree: aTopLevelOp
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelRewriteRule: aTopLevelRewriteRule [
	^ self visitTopLevelRule: aTopLevelRewriteRule
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelRule: aTopLevelRule [
	^ self visitParseTree: aTopLevelRule
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelSort: aTopLevelSort [
	^ self visitParseTree: aTopLevelSort
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelSubsortAxiom: aTopLevelSubsortAxiom [
	^ self visitTopLevelAxiom: aTopLevelSubsortAxiom
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelTerm: aTopLevelTerm [
	^ self visitParseTree: aTopLevelTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelUseContext: aTopLevelUseContext [
	^ self visitParseTree: aTopLevelUseContext
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTerm: aVarTerm [
	^ self visitTerm: aVarTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTermWithSort: aVarTermWithSort [
	^ self visitVarTerm: aVarTermWithSort
]
