Class {
	#name : #LzSortGraph,
	#superclass : #Object,
	#instVars : [
		'sortContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortGraph >> buildSort: anASTPatternNode [
	self flag: #todo.
	^ anASTPatternNode
]

{ #category : #accessing }
LzSortGraph >> sort: aString [
	| astNode |
	astNode := LzParser parse: aString startingAt: #patternEnd yielding: LzASTPattern.
	^ self buildSort: astNode
]

{ #category : #accessing }
LzSortGraph >> sortContext: aSortContext [
	sortContext := aSortContext
]
