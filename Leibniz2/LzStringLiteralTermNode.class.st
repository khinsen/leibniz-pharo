Class {
	#name : #LzStringLiteralTermNode,
	#superclass : #LzLiteralTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzStringLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitStringLiteralTerm: self
]
