Class {
	#name : #LzBindingsVarNode,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'name',
		'sort',
		'value',
		'parent',
		'rank'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzBindingsVarNode >> incrementRank [
	rank := rank + 1
]

{ #category : #initializing }
LzBindingsVarNode >> initialize [
	rank := 0
]

{ #category : #accessing }
LzBindingsVarNode >> name [
	^ name
]

{ #category : #accessing }
LzBindingsVarNode >> name: aVarName [
	name := aVarName
]

{ #category : #accessing }
LzBindingsVarNode >> parent [
	^ parent
]

{ #category : #accessing }
LzBindingsVarNode >> parent: aNode [
	parent := aNode
]

{ #category : #accessing }
LzBindingsVarNode >> rank [
	^ rank
]

{ #category : #accessing }
LzBindingsVarNode >> sort [
	^ sort
]

{ #category : #accessing }
LzBindingsVarNode >> sort: aSort [
	sort := aSort
]

{ #category : #unifying }
LzBindingsVarNode >> unifyWithValue: aTerm bindings: anLzBindings [
	value
		ifNil: [
			anLzBindings failUnless: aTerm sort isSubsortOf: sort.
			self value: aTerm ]
		ifNotNil: [
			value = aTerm
				ifFalse: [ anLzBindings failWith: aTerm notUnifiableWith: value ] ]
]

{ #category : #accessing }
LzBindingsVarNode >> value [
	^ value
]

{ #category : #accessing }
LzBindingsVarNode >> value: aTerm [
	value := aTerm
]

{ #category : #accessing }
LzBindingsVarNode >> valueSlots [
	^ #(name sort value parent rank)
]
