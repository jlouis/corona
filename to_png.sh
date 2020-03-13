#!/bin/bash

# Make PDF
R CMD BATCH corona.R

# Render to PNG
gs -sDEVICE=png16m -sBATCH -sNOPAUSE -r300 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sOutputFile=plot.png plot.pdf