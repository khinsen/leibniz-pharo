Class {
	#name : #LzHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzHomeSection >> defaultPriority [
	^ 30
]

{ #category : #accessing }
LzHomeSection >> leibnizBookCard [
	<gtSectionCard>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Leibniz';
		description: 'Leibniz is a notation for embedding machine-readable computational models in human-readable document.';
		priority: 1;
		pageName: 'Leibniz - a Digital Scientific Notation';
		databaseName: LzBook databaseName;
		readMoreToolbar;
		details: [ :db | 
			| pages pagesWithDeclarations |
			pages := db pages select: #shouldAppearInIndexOrDailyNotes.
			pagesWithDeclarations := pages select: [ :each |
				((each lzDBCache declarationCacheFor: each) declarationsFor: nil) isEmpty not ].
				'The book is expressed as a knowledge base. ',
				'It documents Leibniz in ', pages size asString ,
				' pages, of which ',
				pagesWithDeclarations size asString,
				' contain context definitions.' ]
				yourself
]

{ #category : #accessing }
LzHomeSection >> sectionTitle [
	^ 'Leibniz'
]
