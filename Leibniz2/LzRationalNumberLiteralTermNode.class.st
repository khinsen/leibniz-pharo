Class {
	#name : #LzRationalNumberLiteralTermNode,
	#superclass : #LzLiteralTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzRationalNumberLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitRationalNumberLiteralTerm: self
]
