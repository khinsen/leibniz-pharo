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
	^ #(#(#(#RGMethodDefinition #(#LeibnizSortGraph #make:subsortOf: #false)) #'2018-12-06T17:13:39.514023+01:00') )
]

{ #category : #'code-critics' }
ManifestLeibniz class >> ruleRBModifiesCollectionRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#LeibnizSortGraph #make:subsortOf: #false)) #'2018-12-06T17:14:01.072463+01:00') )
]
