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

## Configuration

You will probably want to change some variables used for generating PDF, Word and Epub. The output directory and reference documents are configurable in ftplugin/markdown.vim

```
" Global variables used by compile functions (you may want to change these)
let OUTPUTDIR = "~/Dropbox/Skrivande/_kompilerat/"
let CSS = "~/dev/compile-story/style/manuscript.css"
let DOCXREF = "~/dev/compile-story/style/reference.docx"
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

## Requirments

The Make-commands require pandoc (http://pandoc.org/) and wkhtmltopdf (http://wkhtmltopdf.org/).
