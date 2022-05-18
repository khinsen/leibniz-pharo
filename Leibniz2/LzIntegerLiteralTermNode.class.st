Class {
	#name : #LzIntegerLiteralTermNode,
	#superclass : #LzLiteralTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzIntegerLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitIntegerLiteralTerm: self
]
