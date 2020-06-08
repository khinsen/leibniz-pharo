# leibniz-pharo

[Leibniz](http://github.com/khinsen/leibniz) runtime library for Pharo. Work in progress, not very usable yet!

To install in a pre-built GToolkit distribution, execute the following lines in a playground:
```
Metacello new
    baseline: 'LeibnizForGToolkit';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```

To install in Pharo 8, execute the following lines in a playground:
```
Metacello new
    baseline: 'Leibniz';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```

Note that Leibniz makes generous use of Unicode glyphs that are not contained in the default fonts used by the standard Pharo images. I have changed the "Default" font to "Arial Unicode MS Regular 10" and the "Code" font to "DejaVu Sans Mono Regular 10", a combination that works well for me under macOS.

## Dependencies

The following list is provided for information. All the dependencies will be installed automatically in the procedure explained above.

- [Roassal](https://github.com/ObjectProfile/Roassal2/) is a powerful graphics engine used for visualizing Leibniz contexts.
- [XMLParser](https://github.com/pharo-contributions/XML-XMLParser/) is used to read Leibniz documents.
- [RecursiveWriteBarrier](https://github.com//khinsen/RecursiveWriteBarrier) is used to make some objects fully immutable.
- [EqualityThroughVariablesTrait](https://github.com/khinsen/EqualityThroughVariablesTrait) is a trait that implements object equality in terms of equality of instance and indexed variables.

