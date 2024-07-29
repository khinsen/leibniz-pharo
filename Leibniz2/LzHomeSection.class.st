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
			| snippets somePages |
			somePages := db pages select: #shouldAppearInIndexOrDailyNotes.
			snippets := somePages flatCollect: #allChildrenDepthFirst.
			'The book is expressed as a knowledge base. It documents the environment in '
				, somePages size asString , ' pages.' ]
				yourself
]

{ #category : #accessing }
LzHomeSection >> sectionTitle [
	^ 'Leibniz'
]
