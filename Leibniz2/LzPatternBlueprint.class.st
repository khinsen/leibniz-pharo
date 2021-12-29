Class {
	#name : #LzPatternBlueprint,
	#superclass : #LzBlueprint,
	#instVars : [
		'term',
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzPatternBlueprint >> fieldNames [
	^ #(term variables)
]

{ #category : #accessing }
LzPatternBlueprint >> term [

	^ term
]

{ #category : #accessing }
LzPatternBlueprint >> term: anObject [

	term := anObject
]

{ #category : #accessing }
LzPatternBlueprint >> variables [

	^ variables
]

{ #category : #accessing }
LzPatternBlueprint >> variables: anObject [

	variables := anObject
]
