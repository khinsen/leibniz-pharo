Class {
	#name : #LzScanner,
	#superclass : #SmaCCScanner,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #'generated-initialization' }
LzScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(22 'forSorts' 10) #(22 'name' 11) #(22 'name=' 12) #(22 'no' 13) #(22 'yes' 14))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
LzScanner >> emptySymbolTokenId [
	^ 61
]

{ #category : #generated }
LzScanner >> errorTokenId [
	^ 62
]

{ #category : #generated }
LzScanner >> scan1 [
	[ self recordMatch: #(22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan10 [
	self step.
	currentCharacter == $- ifTrue: [ self step ].
	(currentCharacter between: $0 and: $9)
		ifTrue: [ [ self recordMatch: #(27).
			self step.
			currentCharacter between: $0 and: $9 ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan11 [
	self recordMatch: #(5 22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan12 [
	self recordMatch: #(16 22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan13 [
	self recordMatch: #(18 22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan14 [
	self recordMatch: #(19 22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan15 [
	self recordMatch: #(20 22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isLzIdentifierCharacter
		or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan2 [
	self recordMatch: #(22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan3 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan3 [
	[ self recordMatch: #(22 25).
	self step.
	currentCharacter == $. ifTrue: [ ^ self scan4 ].
	currentCharacter == $/ ifTrue: [ ^ self scan8 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan4 [
	[ self recordMatch: #(22 27).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan5 [
	self recordMatch: #(22).
	self step.
	currentCharacter == $- ifTrue: [ ^ self scan6 ].
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan6 [
	self recordMatch: #(22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan7 [
	[ self recordMatch: #(22 27).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan8 [
	self recordMatch: #(22).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $1 and: $9) ifTrue: [ ^ self scan9 ].
	(currentCharacter isLzIdentifierCharacter
		or: [ '.0' includes: currentCharacter ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan9 [
	[ self recordMatch: #(22 26).
	self step.
	currentCharacter == $_
		ifTrue: [ [ self recordMatch: #(23).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ])
		ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForToken [
	self step.
	currentCharacter == $"
		ifTrue: [ [ self step.
			currentCharacter == $" ifTrue: [ ^ self recordAndReportMatch: #(24) ].
			true ] whileTrue ].
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	currentCharacter == $) ifTrue: [ ^ self recordAndReportMatch: #(2) ].
	currentCharacter == $, ifTrue: [ ^ self recordAndReportMatch: #(3) ].
	currentCharacter == $- ifTrue: [ ^ self scan2 ].
	currentCharacter == $: ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	currentCharacter == $= ifTrue: [ ^ self scan11 ].
	currentCharacter == $[ ifTrue: [ ^ self recordAndReportMatch: #(6) ].
	currentCharacter == $\ ifTrue: [ ^ self scanForTokenX4 ].
	currentCharacter == $] ifTrue: [ ^ self recordAndReportMatch: #(8) ].
	currentCharacter == $^ ifTrue: [ ^ self scanForTokenX3 ].
	^ self scanForTokenX5
]

{ #category : #generated }
LzScanner >> scanForTokenX1 [
	[ self recordMatch: #(25).
	self step.
	currentCharacter == $.
		ifTrue: [ [ self recordMatch: #(27).
			self step.
			currentCharacter == $e ifTrue: [ ^ self scan10 ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $/
		ifTrue: [ self step.
			(currentCharacter between: $1 and: $9)
				ifTrue: [ [ self recordMatch: #(26).
					self step.
					currentCharacter between: $0 and: $9 ] whileTrue ].
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan10 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX2 [
	[ self recordMatch: #(21).
	self step.
	currentCharacter isSeparator or: [ currentCharacter == Character pageUp ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX3 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX4 [
	self step.
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(7) ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForTokenX5 [
	currentCharacter == ${ ifTrue: [ ^ self recordAndReportMatch: #(15) ].
	currentCharacter == $| ifTrue: [ ^ self scan12 ].
	currentCharacter == $} ifTrue: [ ^ self recordAndReportMatch: #(17) ].
	currentCharacter = (Character value: 8594) ifTrue: [ ^ self scan13 ].
	currentCharacter = (Character value: 8658) ifTrue: [ ^ self scan14 ].
	currentCharacter = (Character value: 8838) ifTrue: [ ^ self scan15 ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scanForTokenX1 ].
	(currentCharacter isSeparator or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scanForTokenX2 ].
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #whitespace)
]
