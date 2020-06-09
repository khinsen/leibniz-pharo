# leibniz-pharo

[Leibniz](http://github.com/khinsen/leibniz) runtime library for Pharo. Work in progress, not very usable yet!

## Installation in a [pre-built GToolkit](https://gtoolkit.com/) distribution

Execute the following lines in a playground:
```
Metacello new
    baseline: 'LeibnizForGToolkit';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```

Note that Leibniz makes generous use of Unicode glyphs that are not contained in the default fonts used by GToolkit. The only suitable free font I have found to replace them is [Arial Unicode MS](https://docs.microsoft.com/en-us/typography/font-list/arial-unicode-ms). To replace the default fonts, paste the following script into a playground and click "Inspect". In the inspector for the resulting `RBCompositeRefactoringChange` (see screenshot below), accept the changes.
![screenshot](https://github.com/khinsen/leibniz-pharo/raw/master/Screenshot%202020-06-09%20at%2014.55.37.png)
(thanks to [@girba](https://github.com/girba) for the refactoring magic in this script!)

## Installation in a Pharo 8 image

Execute the following lines in a playground:
```
Metacello new
    baseline: 'Leibniz';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```

Note that Leibniz makes generous use of Unicode glyphs that are not contained in the default fonts used by the standard Pharo images. I have changed the "Default" font to "Arial Unicode MS Regular 10" and the "Code" font to "DejaVu Sans Mono Regular 10", a combination that works well for me under macOS. Assuming that you have those fonts installed (via macOS), execute the following code in a playground to adapt your Pharo settings:
```
FreeTypeFontProvider current updateFromSystem.

StandardFonts defaultFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 10).

StandardFonts codeFont:
    (LogicalFont
         familyName: 'DejaVu Sans Mono'
         pointSize: 10).

StandardFonts listFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 10).

StandardFonts menuFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 10).

StandardFonts buttonFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 10).

StandardFonts windowTitleFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 11).

StandardFonts balloonFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 9).

StandardFonts haloFont:
    (LogicalFont 
         familyName: 'Arial Unicode MS'
         pointSize: 9).
```

## Dependencies

The following list is provided for information. All the dependencies will be installed automatically in the procedure explained above.

- [Roassal](https://github.com/ObjectProfile/Roassal2/) is a powerful graphics engine used for visualizing Leibniz contexts.
- [XMLParser](https://github.com/pharo-contributions/XML-XMLParser/) is used to read Leibniz documents.
- [RecursiveWriteBarrier](https://github.com//khinsen/RecursiveWriteBarrier) is used to make some objects fully immutable.
- [EqualityThroughVariablesTrait](https://github.com/khinsen/EqualityThroughVariablesTrait) is a trait that implements object equality in terms of equality of instance and indexed variables.
