Class {
	#name : #LzPageContextChanged,
	#superclass : #Announcement,
	#instVars : [
		'page',
		'subcontext'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzPageContextChanged >> page [
	^ page
]

{ #category : #accessing }
LzPageContextChanged >> page: anObject [
	page := anObject
]

{ #category : #accessing }
LzPageContextChanged >> subcontext [
	^ subcontext
]

{ #category : #accessing }
LzPageContextChanged >> subcontext: anObject [
	subcontext := anObject
]
