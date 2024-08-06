Class {
	#name : #LzStepTermNode,
	#superclass : #LzTermNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzStepTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitStepTerm: self
]
