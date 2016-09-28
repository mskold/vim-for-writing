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

You will probably want to change some variables used for generating PDF, Word and Epub, such as output directory, CSS stylesheet (for EPUB and PDF) and reference document for DOCX.

Add this configuration to your .vimrc
```
let g:writemode_outputdir = "<path to your desired output location>"
let g:writemode_cssref = "<path to your custom css-file>"
let g:writemode_docxref = "<path to your reference docx file>"
```

To enable the :MailBackup commmand, you must specify an email address to be used.
```
let g:writemode_backup_emailaddress = "<the email address you want your document to be emailed to>"
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
