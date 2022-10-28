Extension { #name : #Array2D }

{ #category : #'*RecurrenceEquations' }
Array2D >> grownByRows: length [
	^ self class
		rows: (self numberOfRows + length)
		columns: self numberOfColumns
		contents: (contents grownBy: length * self numberOfColumns)
]
