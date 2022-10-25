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
TLzParseTreeNodeVisitor >> visitAssetPrefix: anAssetPrefix [
	^ self visitParseTree: anAssetPrefix
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitBracketOp: aBracketOp [
	^ self visitOp: aBracketOp
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
TLzParseTreeNodeVisitor >> visitOpArg: anOpArg [
	^ self visitParseTree: anOpArg
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitOption: anOption [
	^ self visitParseTree: anOption
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitParenthesizedTerm: aParenthesizedTerm [
	^ self visitTerm: aParenthesizedTerm
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
TLzParseTreeNodeVisitor >> visitRulePrefix: aRulePrefix [
	^ self visitParseTree: aRulePrefix
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitSimpleOpArg: aSimpleOpArg [
	^ self visitOpArg: aSimpleOpArg
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitStringLiteralTerm: aStringLiteralTerm [
	^ self visitLiteralTerm: aStringLiteralTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitSubscriptOp: aSubscriptOp [
	^ self visitOp: aSubscriptOp
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitSubscriptOpTerm: aSubscriptOpTerm [
	^ self visitTerm: aSubscriptOpTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitSuperscriptOp: aSuperscriptOp [
	^ self visitOp: aSuperscriptOp
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
TLzParseTreeNodeVisitor >> visitTopLevelAsset: aTopLevelAsset [
	^ self visitParseTree: aTopLevelAsset
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelEqualityAxiom: aTopLevelEqualityAxiom [
	^ self visitParseTree: aTopLevelEqualityAxiom
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
TLzParseTreeNodeVisitor >> visitTopLevelSpecialTerms: aTopLevelSpecialTerms [
	^ self visitParseTree: aTopLevelSpecialTerms
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTopLevelSubsort: aTopLevelSubsort [
	^ self visitParseTree: aTopLevelSubsort
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
TLzParseTreeNodeVisitor >> visitTupleOp: aTupleOp [
	^ self visitOp: aTupleOp
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitTupleTerm: aTupleTerm [
	^ self visitTerm: aTupleTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVar: aVar [
	^ self visitParseTree: aVar
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTerm: aVarTerm [
	^ self visitTerm: aVarTerm
]

{ #category : #generated }
TLzParseTreeNodeVisitor >> visitVarTermWithSort: aVarTermWithSort [
	^ self visitVarTerm: aVarTermWithSort
]
