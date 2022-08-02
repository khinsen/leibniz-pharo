Class {
	#name : #LzPageDeclarationsChanged,
	#superclass : #Announcement,
	#instVars : [
		'subcontexts',
		'page'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzPageDeclarationsChanged >> page [

	^ page
]

{ #category : #accessing }
LzPageDeclarationsChanged >> page: aLePage [
	page := aLePage
]

{ #category : #accessing }
LzPageDeclarationsChanged >> subcontexts [
	^ subcontexts
]

{ #category : #accessing }
LzPageDeclarationsChanged >> subcontexts: anArray [
	subcontexts := anArray
]
