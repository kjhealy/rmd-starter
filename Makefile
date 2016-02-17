### From Rmd to PDF or html via md

## All Rmarkdown files in the working directory
SRC = $(wildcard *.Rmd)

## Location of Pandoc support files.
PREFIX = /Users/kjhealy/.pandoc

## Location of your working bibliography file
BIB = /Users/kjhealy/Documents/bibs/socbib-pandoc.bib

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSL = apsa

MD=$(SRC:.Rmd=.md)
PDFS=$(SRC:.Rmd=.pdf)
HTML=$(SRC:.Rmd=.html)
TEX=$(SRC:.Rmd=.tex)


all:	$(MD) $(PDFS) $(HTML) $(TEX) 

pdf:	clean $(PDFS)
html:	clean $(HTML)
tex:	clean $(TEX)
md:	clean $(MD)

%.md: %.Rmd
	R --slave -e "set.seed(100);knitr::knit('$<')"

%.html:	%.md 
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -w html -S --template=$(PREFIX)/templates/html.template --css=$(PREFIX)/marked/kultiad-serif.css --filter pandoc-crossref --filter pandoc-citeproc --csl=$(PREFIX)/csl/$(CSL).csl --bibliography=$(BIB) --filter pandoc-citeproc-preamble -o $@ $<

%.tex:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -w latex -s -S --latex-engine=pdflatex --template=$(PREFIX)/templates/latex.template --filter pandoc-crossref --filter pandoc-citeproc --csl=$(PREFIX)/csl/ajps.csl --bibliography=$(BIB) --filter pandoc-citeproc-preamble -o $@ $<


%.pdf:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -w latex -s -S --latex-engine=pdflatex --template=$(PREFIX)/templates/latex.template --filter pandoc-crossref --filter pandoc-citeproc --csl=$(PREFIX)/csl/ajps.csl --bibliography=$(BIB) --filter pandoc-citeproc-preamble -o $@ $<

clean:
	rm -f *.md *.html *.pdf *.tex

.PHONY: clean
