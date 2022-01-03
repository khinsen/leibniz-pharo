Class {
	#name : #LzASTOp,
	#superclass : #LzASTNode,
	#instVars : [
		'sort',
		'args',
		'name',
		'variables'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTOp >> args [

	^ args
]

{ #category : #accessing }
LzASTOp >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzASTOp >> name [

	^ name
]

{ #category : #accessing }
LzASTOp >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzASTOp >> sort [

	^ sort
]

{ #category : #accessing }
LzASTOp >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzASTOp >> valueSlots [
	^ #(name variables args sort)
]

{ #category : #accessing }
LzASTOp >> varDeclarations [
	^ args select: [ :each |
		each class == LzASTVar ]
]

{ #category : #accessing }
LzASTOp >> variables [
	^ variables
]

{ #category : #accessing }
LzASTOp >> variables: aCollection [
	variables := aCollection
]

{ #category : #accessing }
LzASTOp >> withoutVarDeclarations [
	| plainArgs |
	plainArgs := args collect: [ :each |
		each class == LzASTVar
			ifTrue: [ each sort ]
			ifFalse: [ each ] ].
	^ self class new
			name: self name;
			args: plainArgs;
			sort: self sort;
			variables: self variables
]
