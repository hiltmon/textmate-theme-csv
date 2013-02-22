# ThemeCSV TextMate 2 Bundle

**Note: Built and Tested on TextMate 2 only.** I have no idea if this will run on TextMate 1. The themes generated *should* also work with Sublime Text 2.

An easier(?) way to generate TextMate themes (from within TextMate) than to edit those pesky `.plist` files manually. *I created it for my own use so I could have multiple themes by document type, but maybe it could be helpful to others.*

## To create a New Theme

Create a new file using the `BlankTheme.tmcsv` as a starting point. Make sure you:

* Change the `name` element as this is what will be used to create the theme file and bundle
* Change the `uuid` field otherwise the theme will not load. On OS X, just run `uuidgen` from the command line and paste in the new UUID.

## The File Format

The file format is standard CSV with the ability to comment out lines. Comments are lines starting with `//`. Also, no blank lines and no line breaks within lines, please.

The first element of the line defines its type:

### Header Line

There can be only one header line, this is used to name and configure the bundle. Replace the **Author**, **Name**, theme.**Name** and **UUID** for new themes. *Do not generate the new theme until this is done.*

### Main Line

This line *must* have six and only six colors, one for

* Background (the whole screen)
* Foreground (default text)
* Caret
* Selection color
* Invisible element color
* The highlighted line color

### Scope lines

It is recommended that you start with the default scope lines from `BlankTheme.tmcsv`, then add your own.

Each Scope line must contain at least the following elements:

* Scope Name
* Background color OR nil
* Foreground color OR nil
* fontStyle (one of bold, italic, underline or nil)
* One or more TextMate scopes separated by commas (or spaces for embedded scopes). For more on how to use these scopes see the [TextMate manual](http://manual.macromates.com/en/scope_selectors).

For example:

	// Type, author, name, semanticClass, uuid  
	Header, Hilton Lipschitz, CombinedCasts, theme.combinedcasts, 570BB45C-486D-44A6-8683-CFE4F63CE651  
	// Type, background, foreground, caret, selection, invisibles, lineHighlight  
	Main, #232323, #E6E1DC, #888888, #5A647EE0, #404040, #333435  
	// Type, name, background, foreground, fontStyle (bold, italic, underline), scopes (comma separated)  
	Scope, Comment, nil, #BC9458, italic, comment  
	Scope, String, nil, #9AB253, nil, string  
	Scope, Number, nil, #9AB253, nil, constant.numeric  
	Scope, Built-in constant, nil, #6E9CBE, nil, constant.language  
	Scope, User-defined constant, nil, #6E9CBE, nil, constant.character, constant.other  
	Scope, Variable, nil, #D0D0FF, nil, variable.language, variable.other  
	...  

## Testing the Theme

Hit `⌘R` to run the script in the bundle to generate (or update the theme). This bundle saves the newly generated theme in the **Avian** folder under **Library** / **Application Support** which works great for the current Alpha. 

Then set your current TextMate theme to the new theme name. It will appear on the menu under **View** / **Theme**.

*Note that the current editor window does not change. To see your theme changes, switch to another tab showing another file and switch back. Sometimes you need to do this once or twice as TextMate catches up.* Also make sure you do not have a theme specified in any `.tm_properties` files or the new theme will not refresh.

**You can now iterate by editing the `tmcsv` file, `⌘R` the generator, and flipping tabs.**

## Command Line Options

I have also included two scripts in the repo:

`parseTheme.rb` enables you to generate a `.tmcsv` file from an existing theme to see how it looks and works. It searches TextMate's default themes, managed themes, Avian themes or your current folder. The most common use is to write the default `tmcsv` file, e.g.:

````
bin/parseTheme -w Zenburnesque
````

Which will produce `Zenburnesque.tmcsv`.

`genTheme.rb` generates a `.plist` version of the `tmcsv` file and saves that to your current folder. If you use the `-b` parameter, `genTheme.rb` will try to create or update the bundle. If you use the `-w` parameter, it creates a `.tmTheme` file locally for you.

````
bin/genTheme -w MyNewTheme.tmcsv
````

Which will create `MyNewTheme.tmTheme`. Cool.


# Installation

To install:

	git clone git://github.com/hiltmon/textmate-theme-csv  
	cd textmate-theme-csv  

Then drag and drop the `ThemeCSV.tmbundle` using Finder to `~\Library\Application Support\Avian\Bundles`.

**Warning:** This bundle includes a few overrides for the font changes in TextMate 2 Markdown and overrides the default Markdown language file to fix a bug in indented blocks and to create a scope for Liquid tags. Just delete these overrides from your copy of the bundle if you do not want them.

Source can be viewed or forked via GitHub: [http://github.com/hiltmon/textmate-theme-csv](http://github.com/hiltmon/textmate-theme-csv).

# License
(The MIT License)

Copyright (c) 2013 Hilton Lipschitz, [http://www.hiltmon.com](http://www.hiltmon.com), [hiltmon@gmail.com](mailto:hiltmon@gmail.com).  

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
