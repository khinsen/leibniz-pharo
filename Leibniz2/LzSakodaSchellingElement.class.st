Class {
	#name : #LzSakodaSchellingElement,
	#superclass : #BlElement,
	#instVars : [
		'board'
	],
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #accessing }
LzSakodaSchellingElement >> board [
	^ board
]

{ #category : #accessing }
LzSakodaSchellingElement >> board: anLzCheckerboardModel [
	board := anLzCheckerboardModel.
	self update.
]

{ #category : #initializing }
LzSakodaSchellingElement >> initialize [
	super initialize.
	self layout: BlGridLayout horizontal.
	self layout cellSpacing: 7.
	self background: Color gray.
	self constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ].
]

{ #category : #operating }
LzSakodaSchellingElement >> multiplePassAnimation [
	| generator step task |
	generator := self board multiplePassGenerator.

	task := BlRepeatedTaskAction new.
	step := [
		generator atEnd ifTrue: [ task stop ].
		generator next.
		self update.
	].
	task
		delay: 500 milliSeconds;
		action: step.
	self enqueueTask: task
]

{ #category : #updating }
LzSakodaSchellingElement >> update [
	self board ifNil: [ ^ self ].
	self removeChildren.
	self layout columnCount: self board numberOfColumns.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
			| aCellElement |
			aCellElement := LzSakodaSchellingCellElement new.
			aCellElement
				board: board;
				cellPosition: aRow @ aColumn.
			aCellElement addEventHandler:
				(LzSakodaSchellingEventListener new
					board: self board;
					cellPosition: aRow @ aColumn).
			self addChild: aCellElement ] ].
]
