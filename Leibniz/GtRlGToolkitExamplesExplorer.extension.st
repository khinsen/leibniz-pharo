Extension { #name : #GtRlGToolkitExamplesExplorer }

{ #category : #'*Leibniz' }
GtRlGToolkitExamplesExplorer >> gtViewLeibnizExamplesInImageFor: aView [
	<gtView>
	^ ((GtExampleGroup withAll: (RPackageOrganizer default packageNamed: 'Leibniz') gtExamplesContained) gtExamplesFor: aView)
		title: 'Leibniz' translated;
		priority: 17
]
