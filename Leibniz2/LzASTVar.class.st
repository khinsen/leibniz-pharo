Class {
	#name : #LzASTVar,
	#superclass : #LzASTNode,
	#instVars : [
		'sort',
		'name'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTVar >> fieldNames [
	^ #(name sort)
]

{ #category : #accessing }
LzASTVar >> name [

	^ name
]

{ #category : #accessing }
LzASTVar >> name: anObject [

	name := anObject
]

{ #category : #accessing }
LzASTVar >> sort [

	^ sort
]

{ #category : #accessing }
LzASTVar >> sort: anObject [

	sort := anObject
]
