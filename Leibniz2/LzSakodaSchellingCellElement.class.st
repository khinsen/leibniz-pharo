Class {
	#name : #LzSakodaSchellingCellElement,
	#superclass : #BlElement,
	#instVars : [
		'cellPosition',
		'board',
		'position'
	],
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #accessing }
LzSakodaSchellingCellElement >> board [
	^ board
]

{ #category : #accessing }
LzSakodaSchellingCellElement >> board: anObject [
	board := anObject
]

{ #category : #accessing }
LzSakodaSchellingCellElement >> cellPosition [
	^ cellPosition
]

{ #category : #accessing }
LzSakodaSchellingCellElement >> cellPosition: aPoint [
	| cell |
	cellPosition := aPoint.
	cell := board cellAt: aPoint.
	self background: cell color.
	cell isEmpty
		ifFalse: [
			(board agentIsHappyAt: aPoint)
				ifFalse: [ self border: (BlBorder paint: Color red) ] ]
]

{ #category : #initializing }
LzSakodaSchellingCellElement >> initialize [
	super initialize.
	self layout: BlFrameLayout new.
	self size: 20 @ 20.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 5).
]
