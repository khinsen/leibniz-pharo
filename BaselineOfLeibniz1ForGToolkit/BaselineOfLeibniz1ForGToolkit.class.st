Class {
	#name : #BaselineOfLeibniz1ForGToolkit,
	#superclass : #BaselineOf,
	#category : #BaselineOfLeibniz1ForGToolkit
}

{ #category : #baseline }
BaselineOfLeibniz1ForGToolkit >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec postLoadDoIt: #'postload:package:'.

		spec
			baseline: 'RecursiveWriteBarrier' 
			with: [ spec repository: 'github://khinsen/RecursiveWriteBarrier:master/src' ].

		spec
			baseline: 'EqualityThroughVariablesTrait' 
			with: [ spec repository: 'github://khinsen/EqualityThroughVariablesTrait:master/src' ].

		spec
			baseline: 'SingletonTrait' 
			with: [ spec repository: 'github://khinsen/SingletonTrait:master' ].

		spec
			package: 'Leibniz1'
			with: [ spec requires:
						#('RecursiveWriteBarrier'
							'EqualityThroughVariablesTrait'
							'SingletonTrait') ].

]
]

{ #category : #baseline }
BaselineOfLeibniz1ForGToolkit >> postload: loader package: packageSpec [
	LbCodeFont chooseDefaultFamily
]
