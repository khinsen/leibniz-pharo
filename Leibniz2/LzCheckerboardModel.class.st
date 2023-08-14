"
A straightforward Pharo implementation of the agent-based model described in {{gtPage:Schelling's segregation model}}.



"
Class {
	#name : #LzCheckerboardModel,
	#superclass : #Object,
	#instVars : [
		'board',
		'randomGenerator'
	],
	#category : #'Leibniz2-CheckerboardModel'
}

{ #category : #operating }
LzCheckerboardModel >> agent: aSymbol happyAt: aPoint [
	self assert:
		({ self blackCell . self whiteCell } includes: aSymbol).
	^ (self fractionOf: aSymbol inNeighborhoodOfCellAt: aPoint) > (1/2)
]

{ #category : #operating }
LzCheckerboardModel >> agentHappyAt: aPoint [
	^ self
		agent: (board at: aPoint x at: aPoint y)
		happyAt: aPoint
]

{ #category : #agents }
LzCheckerboardModel >> blackCell [
	^ #'*'
]

{ #category : #accessing }
LzCheckerboardModel >> cellAt: aPosition [
	^ board at: aPosition x at: aPosition y
]

{ #category : #testing }
LzCheckerboardModel >> cellIsEmptyAt: aPoint [
	^ (board at: aPoint x at: aPoint y) = self emptyCell
]

{ #category : #operating }
LzCheckerboardModel >> destinationForAgent: aSymbol at: aPoint [
	self emptyCellPositionsSortedByDistanceFrom: aPoint.
]

{ #category : #agents }
LzCheckerboardModel >> emptyCell [
	^ #' '
]

{ #category : #operating }
LzCheckerboardModel >> emptyCellPositions [
	| positions |
	positions := OrderedCollection new.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		(board at: aRow at: aColumn) = self emptyCell ifTrue: [
	 			positions add: aRow @ aColumn ] ] ].
	 ^ positions
]

{ #category : #operating }
LzCheckerboardModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCellPositions collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzCheckerboardModel >> fractionOf: agentKind inNeighborhoodOfCellAt: aPoint [
	| nCells nLikeCells |
	nCells := 0.
	nLikeCells := 0.
	aPoint x - 1 to: aPoint x + 1 do: [ :nbRow |
		aPoint y - 1 to: aPoint y + 1 do: [ :nbColumn |
			| nbPoint |
			nbPoint := nbRow @ nbColumn.
			((self isValidPosition: nbPoint)
				and: [ (self cellIsEmptyAt: nbPoint) not ])
				ifTrue: [
					nCells := nCells + 1.
					(board at: nbRow at: nbColumn) = agentKind
						ifTrue: [ nLikeCells := nLikeCells + 1 ] ] ] ].
	^ nLikeCells / nCells
]

{ #category : #operating }
LzCheckerboardModel >> fullPass [
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		((board at: aRow at: aColumn) = self emptyCell) ifFalse: [
		 		self moveAgentAt: aRow @ aColumn ] ] ]
]

{ #category : #inspecting }
LzCheckerboardModel >> gtBoardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Board';
		priority: 1;
		stencil: [ LzCheckerboardElement new board: self ]; 
		actionButtonIcon: BrGlamorousIcons fromhere 
			tooltip: 'Full pass'
			action: [ :aButton :aTab |
				self fullPass.
				aTab viewContentElement phlow update ];
		yourself
]

{ #category : #initializing }
LzCheckerboardModel >> initialize [
	super initialize.
	board := Array2D rows: 13 columns: 16.
	randomGenerator := Random new.
	self randomInitialOccupationsWithEmptyFraction: 1/3.
]

{ #category : #testing }
LzCheckerboardModel >> isValidPosition: aPoint [
	^ (aPoint x between: 1 and: board numberOfRows)
		and: [ aPoint y between: 1 and: board numberOfColumns ]
]

{ #category : #operating }
LzCheckerboardModel >> moveAgentAt: aPoint [
	| agent |
	agent := board at: aPoint x at: aPoint y.
	(self agentHappyAt: aPoint)
		ifFalse: [
			| destinations |
			destinations := self emptyCellPositionsSortedByDistanceFrom: aPoint.
			destinations ifNotEmpty: [
				| destination |
				destination := destinations first.
				board
					swap: aPoint x at: aPoint y
					with: destination x at: destination y ] ]
]

{ #category : #accessing }
LzCheckerboardModel >> numberOfColumns [
	^ board numberOfColumns
]

{ #category : #accessing }
LzCheckerboardModel >> numberOfRows [
	^ board numberOfRows
]

{ #category : #initializing }
LzCheckerboardModel >> randomInitialOccupationsWithEmptyFraction: aNumber [
	self assert: aNumber > 0.
	self assert: aNumber < 1.
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		| cell |
	 		cell := self emptyCell.
	 		randomGenerator next > aNumber
	 			ifTrue: [ randomGenerator next > 0.5
	 						ifTrue: [ cell := self blackCell ]
	 						ifFalse: [ cell := self whiteCell ] ].
	 		board at: aRow at: aColumn put: cell ] ]
]

{ #category : #agents }
LzCheckerboardModel >> whiteCell [
	^ #'0'
]
