Extension { #name : #Character }

{ #category : #'*Leibniz2' }
Character >> isLzIdentifierCharacter [
	^ self isLetter "Unicode categories Ll Lm Lo Lt Lu"
		or: [ ('-*/☰□' includes: self)
		or: [ self isMathSymbol "Unicode category Sm"
		or: [ self isCurrencySymbol "Unicode category Sc"
		or: [ (self isModifierSymbol "Unicode category Sk"
					and: [ ('^' includes: self) not ])
		or: [ self isOtherSymbol "Unicode category So" ] ] ] ] ]
]
