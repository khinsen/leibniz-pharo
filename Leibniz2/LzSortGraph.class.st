Class {
	#name : #LzSortGraph,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sortContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSortGraph >> fieldNames [
	^ #(sortContext)
]

{ #category : #constructing }
LzSortGraph >> parsedSort: anASTPatternNode [
	^ self sortContext parsedPattern: anASTPatternNode
]

{ #category : #accessing }
LzSortGraph >> parsedSortTerm: anASTTermNode variables: anArrayOfASTVarNodes [
	^ self parsedSort: 
		(LzASTPattern new
			variables: anArrayOfASTVarNodes;
			term: anASTTermNode)
]

{ #category : #constructing }
LzSortGraph >> sort: aString [
	| astNode |
	astNode := LzParser parse: aString startingAt: #patternEnd yielding: LzASTPattern.
	^ self parsedSort: astNode
]

{ #category : #accessing }
LzSortGraph >> sortContext [
	^ sortContext
]

{ #category : #accessing }
LzSortGraph >> sortContext: aSortContext [
	sortContext := aSortContext
]
