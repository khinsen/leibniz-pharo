# leibniz-pharo

The second iteration of [Leibniz](http://github.com/khinsen/leibniz), implemented in [Pharo](http://www.pharo.org/) making heavy use of the [Glamorous Toolkit](https://gtoolkit.com/)

![screenshot](./screenshot.png)


## Installation

### Install a font with all the math symbols

Leibniz makes generous use of Unicode glyphs that are not contained in the default fonts used by GToolkit. The best free fonts I have found is [JuliaMono](https://juliamono.netlify.app/), another option (which I haven't used for a while) is [Arial Unicode MS](https://docs.microsoft.com/en-us/typography/font-list/arial-unicode-ms). Leibniz will automatically select one of them, if available.

### Install [Glamorous Toolkit](https://gtoolkit.com/)

The easiest option is downloading a ready-to-run binary for your system from [the download page](https://gtoolkit.com/download).

### Install Leibniz

1. Open Glamorous Toolkit and click on the playground icon near the top left.

![screenshot](./leibniz-installation-1.png)

2. Paste the following lines of code into the playground:
```
Metacello new
    baseline: 'LeibnizForGToolkit';
    repository: 'github://khinsen/leibniz-pharo/src';
    load.
```
Then click on the arrow highlighted in the screenshot below. Wait until the pane on the right appears. This may take a few minutes. Close the playground 
by clicking on the cross highlighted in the screenshot below.

![screenshot](./leibniz-installation-2.png)

3. Open the Leibniz Book

The installation process has added a big icon labelled "Leibniz Book" to the home screen of Glamorous Toolkit. Click on it to open it.

![screenshot](./leibniz-installation-3.png)

4. Start reading and exploring

Read the first page, and move on as you like, either following links or navigating through the table of contents.

![screenshot](./leibniz-installation-4.png)

### Optional: play with the Leibniz implementation

If you want to correctly display these Unicode glyphs in Pharo code (in strings and symbols used by Leibniz), you have to replace the GToolkit default fonts by [JuliaMono](https://juliamono.netlify.app/) (or another suitable monospaced font). Run the following script from a playground:
```
TBlTextStyleable compile: 'glamorousCodeFont
    self fontName: ''JuliaMono'''.
TBlTextStyleable compile: 'glamorousCodeDefaultFont
    self defaultFontName: ''JuliaMono'''.
```

## Dependencies

The following list is provided for information. All the dependencies will be installed automatically in the procedure explained above.

- [SingletonTrait](https://github.com/khinsen/singletontrait) is used for a few singleton classes.
- [RecursiveWriteBarrier](https://github.com//khinsen/RecursiveWriteBarrier) is used to make some objects fully immutable.
- [EqualityThroughVariablesTrait](https://github.com/khinsen/EqualityThroughVariablesTrait) is a trait that implements object equality in terms of equality of instance and indexed variables.
