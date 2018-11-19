adding
add: aSymbol
   (self includes: aSymbol)
     ifFalse: [ kinds at: aSymbol put: (Set with: aSymbol).
                supersorts at: aSymbol put: Set new.
                subsorts at: aSymbol put: Set new. ].
   ^ aSymbol
