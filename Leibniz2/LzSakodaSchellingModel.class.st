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

{ #category : #'instance creation' }
LzSakodaSchellingModel class >> fromRandomSeed: anInteger [
	^ self new
		randomGenerator: (Random new seed: anInteger);
		yourself
]

{ #category : #operating }
LzSakodaSchellingModel >> agent: agentKind isHappyAt: aPosition [
	| neighbors sameKindNeighbors allNeighbors |
	self assert: agentKind isEmpty not.
	neighbors := self countNeighborsOf: agentKind at: aPosition.
	sameKindNeighbors := neighbors first.
	allNeighbors := neighbors second.
	^ sameKindNeighbors >= (allNeighbors / 2)
]

{ #category : #operating }
LzSakodaSchellingModel >> agentIsHappyAt: aPoint [
	^ self
		agent: (self cellAt: aPoint)
		isHappyAt: aPoint
]

{ #category : #operating }
LzSakodaSchellingModel >> allCellsDo: aBlock [
	1 to: self numberOfRows do: [ :aRow |
	 	1 to: self numberOfColumns do: [ :aColumn |
	 		aBlock value: aRow @ aColumn ] ]
]

{ #category : #operating }
LzSakodaSchellingModel >> allCellsSelect: aBlock [
	| positions |
	positions := OrderedCollection new.
	self allCellsDo: [ :aPoint |
		(aBlock value: aPoint)
			ifTrue: [ positions add: aPoint ] ].
	^ positions
]

{ #category : #accessing }
LzSakodaSchellingModel >> cellAt: aPosition [
	^ board at: aPosition x at: aPosition y
]

{ #category : #accessing }
LzSakodaSchellingModel >> cellAt: aPosition put: aCellOccupation [
	board
		at: aPosition x at: aPosition y
		put: aCellOccupation
]

{ #category : #testing }
LzSakodaSchellingModel >> cellIsEmptyAt: aPoint [
	^ (self cellAt: aPoint) isEmpty
]

{ #category : #operating }
LzSakodaSchellingModel >> countNeighborsOf: agentKind at: aPosition [
	| allNeighbors sameKindNeighbors |
	allNeighbors := 0.
	sameKindNeighbors := 0.
	self neighborhoodOf: aPosition do: [ :nbPosition |
		(self cellIsEmptyAt: nbPosition)
			ifFalse: [
				allNeighbors := allNeighbors + 1.
				(agentKind = (self cellAt: nbPosition))
					ifTrue: [ sameKindNeighbors := sameKindNeighbors + 1 ] ] ].
	^ { sameKindNeighbors . allNeighbors }
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCell [
	^ LzSakodaSchellingEmptyCell new
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellPositionsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCells [
	^ self allCellsSelect: [ :aPosition |
		(self cellIsEmptyAt: aPosition)]
]

{ #category : #operating }
LzSakodaSchellingModel >> emptyCellsSortedByDistanceFrom: aPosition [
	| distancesAndPositions |
	distancesAndPositions := self emptyCells collect: [ :eachPosition |
		{ eachPosition manhattanDistanceTo: aPosition . eachPosition } ].
	^ (distancesAndPositions
		sorted: [ :a :b | a first <= b first ])
		collect: #second
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
	randomGenerator := Random new
]

{ #category : #initializing }
LzSakodaSchellingModel >> initializeBoardWithSize: aPoint fractionEmpty: aNumber [
	self assert: (aNumber between: 0 and: 1).
	board := Array2D rows: aPoint x columns: aPoint y.
	self allCellsDo: [ :eachPoint |
		self cellAt: eachPoint put:
			(randomGenerator next > aNumber
				ifFalse: [ LzSakodaSchellingEmptyCell new]
				ifTrue: [
					randomGenerator next > 0.5
						ifTrue: [ LzSakodaSchellingBlackCell new ]
						ifFalse: [ LzSakodaSchellingWhiteCell new ] ] ) ]
]

{ #category : #testing }
LzSakodaSchellingModel >> isValidPosition: aPoint [
	^ (aPoint x between: 1 and: self numberOfRows)
		and: [ aPoint y between: 1 and: self numberOfColumns ]
]

{ #category : #operating }
LzSakodaSchellingModel >> moveAgentAt: aPoint [
	"Move the agent at aPoint if it is unhappy. Return true if
	 the agent was moved, false otherwise."
	| agent |
	agent := self cellAt: aPoint.
	(self agent: agent isHappyAt: aPoint)
		ifTrue: [ ^ false ].
	(self nearestEmptyCellProvidingHappinessTo: agent currentlyAt: aPoint)
		ifNil: [ ^ false ]
		ifNotNil: [ :happinessPoint |
			self cellAt: aPoint put: LzSakodaSchellingEmptyCell new.
			self cellAt: happinessPoint put: agent.
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
	| nearest |
	"We must make the agent's current cell temporarily empty, because
	 it might be in the neighborhood of the candidate destinations."
	self cellAt: aPoint put: self emptyCell.
	nearest :=
		(self emptyCellPositionsSortedByDistanceFrom: aPoint)
			detect: [ :eachPoint |
				self agent: agent isHappyAt: eachPoint ]
			ifNone: [ nil ].
	self cellAt: aPoint put: agent.
	^ nearest
]

{ #category : #operating }
LzSakodaSchellingModel >> neighborHoodOf: aPosition do: anObject [ 
]

{ #category : #operating }
LzSakodaSchellingModel >> neighborhoodOf: aPosition do: aBlock [ 
	aPosition x - 1 to: aPosition x + 1 do: [ :nbRow |
		aPosition y - 1 to: aPosition y + 1 do: [ :nbColumn |
			| nbPosition |
			nbPosition := nbRow @ nbColumn.
			(nbPosition = aPosition)
				ifFalse: [
					(self isValidPosition: nbPosition)
						ifTrue: [ aBlock value:  nbPosition ] ] ] ]
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfColumns [
	^ board numberOfColumns
]

{ #category : #accessing }
LzSakodaSchellingModel >> numberOfRows [
	^ board numberOfRows
]

{ #category : #accessing }
LzSakodaSchellingModel >> randomGenerator: anObject [
	randomGenerator := anObject 
]

{ #category : #inspecting }
LzSakodaSchellingModel >> spawnDebuggerForCellAt: aPoint [
	self halt.
	self moveAgentAt: aPoint
]
