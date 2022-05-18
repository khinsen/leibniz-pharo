Class {
	#name : #LzFpNumberLiteralTermNode,
	#superclass : #LzLiteralTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzFpNumberLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitFpNumberLiteralTerm: self
]
