Class {
	#name : #LzInfixOpNode,
	#superclass : #LzOpNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzInfixOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitInfixOp: self
]
