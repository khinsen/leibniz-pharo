Class {
	#name : #LzASTOpDeclaration,
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
LzASTOpDeclaration >> args [

	^ args
]

{ #category : #accessing }
LzASTOpDeclaration >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzASTOpDeclaration >> fieldNames [
	^ #(name variables args sort)
]

{ #category : #accessing }
LzASTOpDeclaration >> name [

	^ name
]

{ #category : #accessing }
LzASTOpDeclaration >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzASTOpDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzASTOpDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzASTOpDeclaration >> varDeclarations [
	^ args select: [ :each |
		each class == LzASTVarDeclaration ]
]

{ #category : #accessing }
LzASTOpDeclaration >> variables [
	^ variables
]

{ #category : #accessing }
LzASTOpDeclaration >> variables: aCollection [
	variables := aCollection
]

{ #category : #accessing }
LzASTOpDeclaration >> withoutVarDeclarations [
	| plainArgs |
	plainArgs := args collect: [ :each |
		each class == LzASTVarDeclaration
			ifTrue: [ each sort ]
			ifFalse: [ each ] ].
	^ self class new
			name: self name;
			args: plainArgs;
			sort: self sort;
			variables: self variables
]
