.PHONY: clean

main.pdf: main.tex content/*
	latexmk -pdflatex="pplatex -c pdflatex --" --shell-escape -pdf -interaction=nonstopmode main.tex 2>&1 | tee latexmk_log.txt

clean:
	latexmk -C
	rm -f main.bbl main.run.xml main.pdf
	rm -f latexmk_log.txt
