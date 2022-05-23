Class {
	#name : #LzTopLevelAxiomNode,
	#superclass : #LzParseTreeNode,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelAxiomNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelAxiom: self
]
