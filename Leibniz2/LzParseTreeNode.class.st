Class {
	#name : #LzParseTreeNode,
	#superclass : #SmaCCParseNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParseTreeNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitParseTree: self
]
