Class {
	#name : #LzHtmlPageExporter,
	#superclass : #LeHtmlPageExporter,
	#category : #'Leibniz2-HTML-Export'
}

{ #category : #accessing }
LzHtmlPageExporter class >> exportPage: page to: directory [
	| pageLinks context database html pageLinkBuilder |
	database := page database.
	context := LeHtmlContext new
			page: page;
			database: database.
	
	pageLinkBuilder := LeExportPageLinksBuilder new
			in: [ :theBuilder | database ifNotNil: [ theBuilder database: database ] ];
			mainPage: page;
			sequencer: context sequencer;
			html;
			build.
	pageLinks := pageLinkBuilder links.
	context pageLinks: pageLinks.
	
	LeHtmlAssetsUtility
		addAssetResourcesFrom: LzBook htmlAssetLocation
		into: context resources.

	html := LeHtmlPageExporter new
			context: context;
			piece: (LeHtmlGtBookPiece fromFile: LzBook htmlSinglePageTemplateLocation);
			contents.

	context resources
		addResource: (LeExportPageOutputResource new
				content: html;
				hrefBuilder: context hrefBuilder;
				pageLink: (pageLinks
						linkForPage: page
						ifFound: [ :thePage | thePage ]
						ifNone: [  "ignore" ])).
						
	context assembler assemble.
						
	LeExportResourcesDirectorySaver new
		resources: context resources;
		rootDirectory: directory;
		save.

	^ LeHtmlPage new
		directory: directory;
		pageFile: directory / pageLinkBuilder mainFileName;
		resources: context resources;
		log: context log
]
