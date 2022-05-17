Trait {
	#name : #TLzAST2NodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
TLzAST2NodeVisitor >> visitAST2: anAST2 [
	^ self visitSmaCCParseNode: anAST2
]
