Class {
	#name : #LzVarTermNode,
	#superclass : #LzTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzVarTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitVarTerm: self
]
