# leibniz-pharo

[Leibniz](http://github.com/khinsen/leibniz) runtime library for Pharo. Work in progress, not useable yet!

To install in Pharo 7, execute the following lines in a playground:
```
Metacello new
    baseline: 'Leibniz';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```

Note that Leibniz makes generous use of Unicode glyphs that are not contained in the default fonts used by the standard Pharo images. I have changed the "Default" font to "Arial Unicode MS Regular 10" and the "Code" font to "DejaVu Sans Mono Regular 10", a combination that works well for me under macOS.
