Class {
	#name : #LzAST2Node,
	#superclass : #SmaCCParseNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzAST2Node >> acceptVisitor: anAST2Visitor [
	^ anAST2Visitor visitAST2: self
]
