Class {
	#name : #LzTermNode,
	#superclass : #LzParseTreeNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTerm: self
]
