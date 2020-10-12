"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestLeibniz,
	#superclass : #PackageManifest,
	#category : #'Leibniz-Manifest'
}

{ #category : #'code-critics' }
ManifestLeibniz class >> ruleRBCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LbSortGraph #make:subsortOf: #false)) #'2018-12-06T17:13:39.514023+01:00') )
]

{ #category : #'code-critics' }
ManifestLeibniz class >> ruleRBLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LeibnizBuiltinsTest #testTruth #false)) #'2019-01-09T11:47:27.30381+01:00') )
]

{ #category : #'code-critics' }
ManifestLeibniz class >> ruleRBModifiesCollectionRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LbSortGraph #make:subsortOf: #false)) #'2018-12-06T17:14:01.072463+01:00') )
]

{ #category : #'code-critics' }
ManifestLeibniz class >> ruleRBToDoRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LeibnizOperator #addArity:withSort: #false)) #'2019-01-09T13:50:59.272035+01:00') )
]
