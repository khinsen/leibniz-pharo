"
An implementation of [xoshiro256**](https://prng.di.unimi.it/xoshiro256starstar.c). Initialization from a small integer seed via [splitmix64](https://rosettacode.org/wiki/Pseudo-random_numbers/Splitmix64).
"
Class {
	#name : #LzRandom,
	#superclass : #Object,
	#instVars : [
		'signature',
		'seed'
	],
	#category : #'Leibniz2-Random'
}

{ #category : #operating }
LzRandom >> integerBetween: min and: max [
	| numberOfBins binSize |
	numberOfBins := max - min + 1.
	binSize := (2 ** 64) // numberOfBins.
	^ [ :x |
		| result |
		result := (x // binSize) + min.
		result > max
			ifTrue: [ nil ]
			ifFalse: [ result ] ]
]

{ #category : #operating }
LzRandom >> next [
	| result temp |
	result := ((self rotl: seed second * 5 by: 7) * 9)
				bitAnd: 16rFFFFFFFFFFFFFFFF.
	temp := (seed second << 17)
				bitAnd: 16rFFFFFFFFFFFFFFFF.
	seed at: 3 put: ((seed at: 3) bitXor: (seed first)).
	seed at: 4 put: ((seed at: 4) bitXor: (seed second)).
	seed at: 2 put: ((seed at: 2) bitXor: (seed third)).
	seed at: 1 put: ((seed at: 1) bitXor: (seed fourth)).
	seed at: 3 put: temp.
	seed at: 4 put: (self rotl: seed fourth by: 45).
	^ result
"	const uint64_t result = rotl(s[1] * 5, 7) * 9;

	const uint64_t t = s[1] << 17;

	s[2] ^= s[0];
	s[3] ^= s[1];
	s[1] ^= s[2];
	s[0] ^= s[3];

	s[2] ^= t;

	s[3] = rotl(s[3], 45);

	return result;"
]

{ #category : #operating }
LzRandom >> next: anInteger transformedBy: aBlock [
	| result |
	result := Array new: anInteger.
	1 to: result size do: [ :index |
		result at: index put: (self nextTransformedBy: aBlock) ].
	^ result
]

{ #category : #operating }
LzRandom >> nextTransformedBy: aBlock [
	| result |
	[ result ] whileNil:
		[ result := aBlock value: self next ].
	^ result
]

{ #category : #printing }
LzRandom >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	self seed printOn: aStream.
	aStream << $)
]

{ #category : #operating }
LzRandom >> randomChoiceWithFraction: aRational [
	| threshold |
	self assert: aRational >= 0.
	self assert: aRational <= 1.
	threshold := (2 ** 64) * aRational.
	^ [ :x | x < threshold ]
]

{ #category : #private }
LzRandom >> rotl: x by: k [
	^ ((x << k) | (x >> (64 - k)))
		bitAnd: 16rFFFFFFFFFFFFFFFF
"static inline uint64_t rotl(const uint64_t x, int k) {
	return (x << k) | (x >> (64 - k));
}"
]

{ #category : #accessing }
LzRandom >> seed [
	| integerSeed |
	integerSeed := 0.
	seed do: [ :each |
		integerSeed := (integerSeed << 64) bitOr: each ].
	^ integerSeed
]

{ #category : #accessing }
LzRandom >> seed: anInteger [
	| rest |
	seed := Array new: 4.
	rest := anInteger.
	seed size to: 1 by: -1 do: [ :index |
		seed at: index put: (rest bitAnd: 16rFFFFFFFFFFFFFFFF).
		rest := rest >> 64 ].
	self assert: rest equals: 0.
"	self assert: anArray size equals: 4.
	anArray do: [ :each | self assert: each >= 0 ].
	seed := anArray collect: [ :each | each bitAnd: 16rFFFFFFFFFFFFFFFF ]"
]

{ #category : #accessing }
LzRandom >> seedFromSmallInteger: anIntegerSeed [
	"splitmix64"
	| state |
	state := anIntegerSeed bitAnd: 16rFFFFFFFFFFFFFFFF.
	seed := Array new: 4.
	1 to: seed size do: [ :index |
		| z |
		state := (state + 16r9e3779b97f4a7c15)
					bitAnd: 16rFFFFFFFFFFFFFFFF.
		z := state.
		z := ((z bitXor: (z >> 30)) * 16rbf58476d1ce4e5b9)
				bitAnd: 16rFFFFFFFFFFFFFFFF.
		z := ((z bitXor: (z >> 27)) * 16r94d049bb133111eb)
				bitAnd: 16rFFFFFFFFFFFFFFFF.
		seed at: index put: (z bitXor: (z >> 31)) ]

"Original C code:
    uint64 state                                  /* The state can be seeded with any (upto) 64 bit integer value. */

    next_int() {
        state += 0x9e3779b97f4a7c15               /* increment the state variable */
        uint64 z = state                          /* copy the state to a working variable */
        z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9  /* xor the variable with the variable right bit shifted 30 then multiply by a constant */
        z = (z ^ (z >> 27)) * 0x94d049bb133111eb  /* xor the variable with the variable right bit shifted 27 then multiply by a constant */
        return z ^ (z >> 31)                      /* return the variable xored with itself right bit shifted 31 */
    }"
]
