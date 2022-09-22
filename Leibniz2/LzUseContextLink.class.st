Class {
	#name : #LzUseContextLink,
	#superclass : #LeTextualLink,
	#category : #'Leibniz2-Lepiter'
}

{ #category : #printing }
LzUseContextLink >> printOn: aStream [
	self targetPageTitle ifNil: [ ^ super printOn: aStream ].
	aStream
		nextPutAll: 'Context Link: ';
		nextPutAll: self targetUID
]

{ #category : #accessing }
LzUseContextLink >> targetPageTitle [
	<return: #String>
	^ self targetReference pageTitle
]

{ #category : #accessing }
LzUseContextLink >> targetPageTitle: aString [
	self assert: [ aString notNil ].
	self assert: [ targetReference isNil ].
	
	targetReference := LeLinkPageTextualTitleReference 
		forPageTitle: aString.
	targetReference explicitLink: self
]

{ #category : #'api - accepting' }
LzUseContextLink >> targetUID [
	<return: #String>
	^ self targetPageTitle
]
