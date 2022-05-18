Class {
	#name : #LzLiteralTermNode,
	#superclass : #LzTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitLiteralTerm: self
]
