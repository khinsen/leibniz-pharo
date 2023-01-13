Class {
	#name : #LzOpDeclaration,
	#superclass : #LzDeclarationWithVariables,
	#instVars : [
		'sort',
		'args',
		'name'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzOpDeclaration >> addBodyAsRopedTextTo: aRopedText [
	self name addForArity: args withSort: self sort asRopedTextTo: aRopedText
]

{ #category : #accessing }
LzOpDeclaration >> args [

	^ args
]

{ #category : #accessing }
LzOpDeclaration >> args: anObject [

	args := anObject
]

{ #category : #accessing }
LzOpDeclaration >> extractContravariance [
	| argDeclarations contravariant plainArgs plainOpDecl |
	self flag: #contravariant.
	argDeclarations:= self args collect: #declaration.
	contravariant := argDeclarations collect: [ :each |
		(each opName
			= (LzPrefixOpName for: LzConstants opNameContravariant))
			and: [ (each args size = 1)
					and: [ each args first opName
							= (LzPrefixOpName for: LzConstants opNameSort) ] ] ].
	plainArgs := argDeclarations with: contravariant
					collect: [ :decl :flag |
						flag
							ifTrue: [ decl args first ]
							ifFalse: [ decl ] ].
	plainOpDecl := LzOpDeclaration new
					name: self name;
					args: plainArgs;
					sort: self sort;
					variables: self variables.
	^ { contravariant . plainOpDecl }
]

{ #category : #accessing }
LzOpDeclaration >> name [

	^ name
]

{ #category : #accessing }
LzOpDeclaration >> name: anObject [

	name := anObject
]

{ #category : #constructing }
LzOpDeclaration >> objectFor: aContext [
	^ aContext signature operators findOp: self
]

{ #category : #printing }
LzOpDeclaration >> printBodyAsLeibnizSyntaxOn: aStream [
	self name printForArity: args withSort: self sort on: aStream
]

{ #category : #accessing }
LzOpDeclaration >> sort [

	^ sort
]

{ #category : #accessing }
LzOpDeclaration >> sort: anObject [

	sort := anObject
]

{ #category : #accessing }
LzOpDeclaration >> valueSlots [
	^ #(name variables args sort)
]
