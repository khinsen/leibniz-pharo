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
LzOpDeclaration >> rewriteContravariance [
	| argDeclarations contravariant
	  plainArgs contravarianceCode opSort rewrittenOpDecl |
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
	contravarianceCode := contravariant
		inject: 0
		into: [ :sum :each |
				(2 * sum) + (each ifTrue: [ 1 ] ifFalse: [ 0 ]) ].
	contravarianceCode = 0 ifTrue: [ ^ self ].
	opSort := LzOpTermDeclaration new
				opName: (LzPrefixOpName for: LzConstants opNameSort);
				args: {LzIntegerLiteralDeclaration new
							value: contravarianceCode }.
	rewrittenOpDecl := LzOpDeclaration new
					name: self name;
					args: plainArgs;
					sort: opSort;
					variables: self variables.
	^ rewrittenOpDecl
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
