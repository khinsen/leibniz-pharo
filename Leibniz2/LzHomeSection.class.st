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
"	self
		newLepiterPageCardForPageNamed: 'Leibniz - a Digital Scientific Notation'
		inDatabaseNamed: LzBook databaseName
		withTitle: 'Leibniz'
		andDescription: 'Leibniz is a notation for embedding machine-readable computational models in human-readable document.'."
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Leibniz';
		description: 'Leibniz is a notation for embedding machine-readable computational models in human-readable document.';
		priority: 1;
		pageName: 'Leibniz - a Digital Scientific Notation';
		databaseName: LzBook databaseName;
		readMoreToolbar;
		details: [ :db | 
			| snippets somePages |
			somePages := db pages select: #shouldAppearInIndexOrDailyNotes.
			snippets := somePages flatCollect: #allChildrenDepthFirst.
			'The book is expressed as a knowledge base. It documents the environment in '
				, somePages size asString , ' lovely pages containing '
				, snippets size asString , ' snippets of '
				, (snippets groupedBy: #class) size asString , ' different kinds.' ]
				yourself
]
