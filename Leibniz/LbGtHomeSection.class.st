Class {
	#name : 'LbGtHomeSection',
	#superclass : 'GtHomeSection',
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'initialization' }
LbGtHomeSection >> create [
	| sectionContainer cardContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer addChild: (self newSectionTitle: 'Leibniz').
	cardContainer := self newCardsContainer.
	cardContainer addChild: self documentationCard.
	sectionContainer addChild: cardContainer.
	^ sectionContainer
]

{ #category : 'initialization' }
LbGtHomeSection >> documentationCard [
	^ self
		newToolCardWithTitle: 'Leibniz'
		icon: (LeIcons lepiterDatabase create asScalableElement size: 64 @ 64)
		action: [ :card |
			self
				showSpaceWithTitle: 'Leibniz Documentation'
				with: (GtInspector createOn: LbDocumentation new database)
				from: card ]
		description: 'Learning about Leibniz'
]
