Class {
	#name : #LzSakodaSchellingEventListener,
	#superclass : #BlEventListener,
	#instVars : [
		'board',
		'cellPosition'
	],
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #accessing }
LzSakodaSchellingEventListener >> board [
	^ board
]

{ #category : #accessing }
LzSakodaSchellingEventListener >> board: anObject [
	board := anObject
]

{ #category : #accessing }
LzSakodaSchellingEventListener >> cellPosition [
	^ cellPosition
]

{ #category : #accessing }
LzSakodaSchellingEventListener >> cellPosition: anObject [
	cellPosition := anObject
]

{ #category : #accessing }
LzSakodaSchellingEventListener >> clickEvent: anEvent [
	board ifNil: [ ^ self ].
	board spawnDebuggerForCellAt: cellPosition
]
