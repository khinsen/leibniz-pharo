Class {
	#name : #LzASTRule,
	#superclass : #LzASTNode,
	#instVars : [
		'variables',
		'pattern',
		'condition'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTRule >> condition [
	^ condition
]

{ #category : #accessing }
LzASTRule >> condition: aTermNode [
	condition := aTermNode
]

{ #category : #accessing }
LzASTRule >> pattern [
	^ pattern
]

{ #category : #accessing }
LzASTRule >> pattern: aTermNode [
	pattern := aTermNode
]

{ #category : #printing }
LzASTRule >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables do:
		[ :var |
			aStream nextPutAll: '∀ '.
			var printAsLeibnizSyntaxOn: aStream.
			aStream nextPut: Character space]
]

{ #category : #accessing }
LzASTRule >> valueSlots [
	^ #(variables pattern condition)
]

{ #category : #accessing }
LzASTRule >> variables [
	^ variables
]

{ #category : #accessing }
LzASTRule >> variables: anObject [
	variables := anObject
]
