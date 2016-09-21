# VIM writing plugin

A Vim plugin which adds some conveniant commands and settings for writing.

It provides custom folding for Markdown-files, substituting the number of lines folded for a word count of the folded text.
It can also provide a synopsis of the folded section, if that synopsis is available in a HTML-comment directly following the heading.

Example:

```
### Chapter 1
<!-- Establish the main protagonist and something exciting happens. -->

Lorem ipsum ...
```

Folded, the above chapter whould like something like this:

```
### Chapter 1 [Establish the main protagonist and something exciting happens.] (~3 ord)
```

## Commands

    :MakeEpub

Creates an epub file from the current markdown file.

    :MakePDF

Creates a PDF from the current markdown file.

    :MakeWordDoc

Creates a Microsoft Word document from the current markdown file.

    :RenumberChapters

Given that chapter headings are shaped like ```### X``` where X is the chapter number, this command renumbers all chapters from the beginnning of the file. Useful if you are moving chapters around.


