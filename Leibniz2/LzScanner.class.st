Class {
	#name : #LzScanner,
	#superclass : #SmaCCScanner,
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzScanner >> emptySymbolTokenId [
	^ 15
]

{ #category : #generated }
LzScanner >> errorTokenId [
	^ 16
]

{ #category : #generated }
LzScanner >> scan1 [
	[ self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. or: [ currentCharacter between: $0 and: $9 ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan10 [
	self step.
	currentCharacter == $- ifTrue: [ self step ].
	(currentCharacter between: $0 and: $9)
		ifTrue:
			[ [ self recordMatch: #(6).
			self step.
			currentCharacter between: $0 and: $9 ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan2 [
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan3 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan3 [
	[ self recordMatch: #(4).
	self step.
	currentCharacter == $. ifTrue: [ ^ self scan4 ].
	currentCharacter == $/ ifTrue: [ ^ self scan8 ].
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
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
	[ self recordMatch: #(6).
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter == $e ifTrue: [ ^ self scan5 ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan5 [
	self step.
	currentCharacter == $- ifTrue: [ ^ self scan6 ].
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan6 [
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $0 and: $9) ifTrue: [ ^ self scan7 ].
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan7 [
	[ self recordMatch: #(6).
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan8 [
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter between: $1 and: $9) ifTrue: [ ^ self scan9 ].
	(currentCharacter isLzIdentifierCharacter or: [ '.0' includes: currentCharacter ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scan9 [
	[ self recordMatch: #(5).
	self step.
	currentCharacter == $_
		ifTrue:
			[ [ self recordMatch: #(2).
			self step.
			currentCharacter == $_ ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter between: $0 and: $9 ] whileTrue.
	(currentCharacter isLzIdentifierCharacter or: [ currentCharacter == $. ]) ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> scanForToken [
	self step.
	currentCharacter == $"
		ifTrue:
			[ [ self step.
			currentCharacter == $" ifTrue: [ ^ self recordAndReportMatch: #(3) ].
			true ] whileTrue ].
	currentCharacter == $- ifTrue: [ ^ self scan2 ].
	(currentCharacter between: $0 and: $9)
		ifTrue:
			[ [ self recordMatch: #(4).
			self step.
			currentCharacter == $.
				ifTrue:
					[ [ self recordMatch: #(6).
					self step.
					currentCharacter == $e ifTrue: [ ^ self scan10 ].
					currentCharacter between: $0 and: $9 ] whileTrue.
					^ self reportLastMatch ].
			currentCharacter == $/
				ifTrue:
					[ self step.
					(currentCharacter between: $1 and: $9)
						ifTrue:
							[ [ self recordMatch: #(5).
							self step.
							currentCharacter between: $0 and: $9 ] whileTrue ].
					^ self reportLastMatch ].
			currentCharacter == $e ifTrue: [ ^ self scan10 ].
			currentCharacter between: $0 and: $9 ] whileTrue.
			^ self reportLastMatch ].
	(currentCharacter isSeparator or: [ currentCharacter == Character pageUp ])
		ifTrue:
			[ [ self recordMatch: #(1).
			self step.
			currentCharacter isSeparator or: [ currentCharacter == Character pageUp ] ] whileTrue.
			^ self reportLastMatch ].
	currentCharacter isLzIdentifierCharacter ifTrue: [ ^ self scan1 ].
	^ self reportLastMatch
]

{ #category : #generated }
LzScanner >> tokenActions [
	^ #(#whitespace)
]
