Class {
	#name : #LzASTNode,
	#superclass : #Object,
	#category : #'Leibniz2-Parser'
}

{ #category : #comparing }
LzASTNode >> = anObject [
	self == anObject ifTrue: [ ^true ].
	self class = anObject class ifFalse: [ ^false ].
	self fieldNames do: [ :field |
		(self instVarNamed: field) = (anObject instVarNamed: field)
				ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #converting }
LzASTNode >> associations [
	^ self fieldNames collect: [ :each |
		each -> (self instVarNamed:  each) ]
]

{ #category : #accessing }
LzASTNode >> fieldNames [
	^ self class allInstVarNames
]

{ #category : #inspecting }
LzASTNode >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Tree';
		priority: 1;
		items: [ self associations ];
		children: [ :each | 
			each value isLzASTNode
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Field' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #comparing }
LzASTNode >> hash [
	^ self fieldNames
		inject: self class hash
		into: [ :total :each |
			total bitXor: (self instVarNamed: each) hash ]
]

{ #category : #testing }
LzASTNode >> isLzASTNode [
	^ true
]

{ #category : #printing }
LzASTNode >> printOn: aStream [
	super printOn: aStream.
	self associations printElementsOn: aStream.
]
