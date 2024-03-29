Class {
	#name : #LzGtHomeSection,
	#superclass : #GtHomeSection,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #initialization }
LzGtHomeSection >> create [
	| sectionContainer cardContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Leibniz').
	cardContainer := self newCardsContainer.
	cardContainer addChild: self documentationCard.
	self class methods
		select: [ :each | each protocol beginsWith: '*' ]
		thenDo: [ :each |
			cardContainer
				addChild: (self perform: each selector) ].
	sectionContainer addChild: cardContainer.
	^ sectionContainer
]

{ #category : #accessing }
LzGtHomeSection >> documentationCard [
	^ self
		newHeaderCardWithTitle: 'Leibniz'
		description: 'Read the Leibniz book'
		size: 200@150
		content:
			(BrLabel new
				text: 'Leibniz Book';
				aptitude: BrGlamorousLabelAptitude new
					bold;
				padding: (BlInsets all: 20)) asScalableElement
		action: [ :card | 
			| startPage |
			startPage := LzBook pageNamed: 'Leibniz - a Digital Scientific Notation'.
			GtWorldUtility 
				showSpaceWithTitle: startPage title
				inPagerWith: [ startPage
					asLepiterPagePhlowTool asElementDo: [ :e | e ] ] asStencil
				from: card ].
]
