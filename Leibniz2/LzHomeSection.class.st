Class {
	#name : #LzHomeSection,
	#superclass : #GtHomeSection,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #initialization }
LzHomeSection >> create [
	| sectionContainer cardContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Leibniz').
	cardContainer := self newCardsContainer.
	cardContainer addChild: self leibnizBookCard.
	cardContainer inspect.
	self class methods
		select: [ :each | each protocol beginsWith: '*' ]
		thenDo: [ :each |
			cardContainer
				addChild: (self perform: each selector) ].
	sectionContainer addChild: cardContainer.
	^ sectionContainer
]

{ #category : #accessing }
LzHomeSection >> leibnizBookCard [
	^ self
		newLepiterPageCardForPageNamed: 'Leibniz - a Digital Scientific Notation'
		inDatabaseNamed: LzBook databaseName
		withTitle: 'Leibniz'
		andDescription: 'Leibniz is a notation for embedding machine-readable computational models in human-readable document.'
]
