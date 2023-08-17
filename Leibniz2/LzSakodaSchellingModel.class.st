"
A straightforward Pharo implementation of the agent-based model described in {{gtPage:Schelling's segregation model}}.

"
Class {
	#name : #LzSakodaSchellingModel,
	#superclass : #Object,
	#instVars : [
		'board',
		'randomGenerator'
	],
	#category : #'Leibniz2-SakodaSchellingModel'
}

{ #category : #operating }
LzSakodaSchellingModel >> agent: aCellOccupation isHappyAt: aPoint [
	self assert: aCellOccupation isEmpty not.
	^ (self fractionOf: aCellOccupation inNeighborhoodOfCellAt: aPoint) >= (1/2)
]

{ #category : #operating }
LzSakodaSchellingModel >> agentIsHappyAt: aPoint [
	^ self
		agent: (board at: aPoint x at: aPoint y)
		isHappyAt: aPoint
]

{ #category : #operating }
LzSakodaSchellingModel >> allCellsDo: aBlock [
	1 to: board numberOfRows do: [ :aRow |
	 	1 to: board numberOfColumns do: [ :aColumn |
	 		aBlock value: aRow @ aColumn ] ]
]

{ #category : #accessing }
LzSakodaSchellingModel >> cellAt: aPosition [
	^ board at: aPosition x at: aPosition y
]

{ #category : #testing }
LzSakodaSchellingModel >> cellIsEmptyAt: aPoint [
	^ (board at: aPoint x at: aPoint y) isEmpty
]

{ #category : #operating }
LzSakodaSchellingModel >> destinationForAgent: aSymbol at: aPoint [
	self emptyCellPositionsSortedByDistanceFrom: aPoint.
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellPositions [
	| positions |
	positions := OrderedCollection new.
	self allCellsDo: [ :aPoint |
		(self cellIsEmptyAt: aPoint)
			ifTrue: [ positions add: aPoint ] ].
	 ^ positions
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCellPositions collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzSakodaSchellingModel >> fractionOf: agentKind inNeighborhoodOfCellAt: aPoint [
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
LzSakodaSchellingModel >> fullPass [
	"Do a full pass over the board, attempting to move all unhappy
	 agents. Return true if any agent was moved, false otherwise."
	| moved |
	moved := false.
	self allCellsDo: [ :eachPoint |
		(self cellIsEmptyAt: eachPoint) ifFalse: [
			(self moveAgentAt: eachPoint)
				 ifTrue: [ moved := true ] ] ].
	^ moved
]

{ #category : #inspecting }
LzSakodaSchellingModel >> gtBoardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Board';
		priority: 1;
		stencil: [ LzSakodaSchellingElement new board: self ];
		actionButtonIcon: BrGlamorousIcons fromhere 
			tooltip: 'One pass'
			action: [ :aButton :aTab |
				self fullPass.
				aTab viewContentElement children first update ];
		actionButtonIcon: BrGlamorousVectorIcons play 
			tooltip: 'Animation'
			action: [ :aButton :aTab |
				aTab viewContentElement children first multiplePassAnimation ];
		yourself
]

{ #category : #initializing }
LzSakodaSchellingModel >> initialize [
	super initialize.
	board := Array2D rows: 13 columns: 16.
	randomGenerator := Random new.
	self randomInitialOccupationsWithEmptyFraction: 1/3.
]

{ #category : #testing }
LzSakodaSchellingModel >> isValidPosition: aPoint [
	^ (aPoint x between: 1 and: board numberOfRows)
		and: [ aPoint y between: 1 and: board numberOfColumns ]
]

{ #category : #operating }
LzSakodaSchellingModel >> moveAgentAt: aPoint [
	"Move the agent at aPoint if it is unhappy. Return true if
	 the agent was moved, false otherwise."
	| agent |
	agent := board at: aPoint x at: aPoint y.
	(self agent: agent isHappyAt: aPoint)
		ifTrue: [ ^ false ].
	(self nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint)
		ifNil: [ ^ false ]
		ifNotNil: [ :happinessPoint |
			board
				swap: aPoint x at: aPoint y
				with: happinessPoint x at: happinessPoint y.
			^ true ]
]

{ #category : #operating }
LzSakodaSchellingModel >> multiplePassGenerator [
	^ Generator on: [ :g |
		[
			| moved |
			moved := false.
			self allCellsDo: [ :eachPoint |
				(self cellIsEmptyAt: eachPoint) ifFalse: [
					(self moveAgentAt: eachPoint)
						ifTrue: [
							moved := true.
							g yield: eachPoint ] ] ].
			moved ] whileTrue ]
]

{ #category : #operating }
LzSakodaSchellingModel >> nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint [
	(self emptyCellPositionsSortedByDistanceFrom: aPoint)
		detect: [ :eachPoint |
			self agent: agent isHappyAt: eachPoint ]
		ifFound: [ :happinessPoint | ^ happinessPoint ].
	^ nil
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfColumns [
	^ board numberOfColumns
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfRows [
	^ board numberOfRows
]

{ #category : #initializing }
LzSakodaSchellingModel >> randomInitialOccupationsWithEmptyFraction: aNumber [
	self assert: aNumber > 0.
	self assert: aNumber < 1.
	self allCellsDo: [ :eachPoint |
		| cellOccupation |
		cellOccupation :=
			randomGenerator next > aNumber
				ifFalse: [ LzSakodaSchellingEmptyCell new]
				ifTrue: [
					randomGenerator next > 0.5
	 					ifTrue: [ LzSakodaSchellingBlackCell new ]
	 					ifFalse: [ LzSakodaSchellingWhiteCell new ] ].
		board at: eachPoint x at: eachPoint y put: cellOccupation ]
]

{ #category : #inspecting }
LzSakodaSchellingModel >> spawnDebuggerForCellAt: aPoint [
	self halt.
	self moveAgentAt: aPoint
]
