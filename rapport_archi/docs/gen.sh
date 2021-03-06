#!/bin/sh
# TeX file generation

# Source info file:
. ./infos

FILE=${FILE}.tex

echo "% $TITLE - $AUTHOR" > $FILE

# Document class
echo "
\documentclass[twoside]{$DCLASS}
\usepackage{hyperref}
" >> $FILE

# To include pictures
echo "
\usepackage{graphicx}
\usepackage{subfig}
\usepackage{placeins}
\usepackage{rotating}
" >> $FILE

# Encoding settings
if [ $CENC == "utf-8" ]
then
    echo "
% Unicode encoding  
\usepackage[utf8x]{inputenc}
" >> ${FILE}
    BADENC="latin1"
else
    BADENC="utf-8"
fi

# Colorfull Text
echo "
% Colorfull Text
\usepackage{xcolor}
" >> ${FILE}

# €
echo "
% \euro
\usepackage{eurosym}
" >> ${FILE}

# Language setting
echo "
% Language settings:
\usepackage[$LANG]{babel}
" >> ${FILE}
# If french we have to use T1 fontenc instead of OT1
if [ $LANG="french" ] || [ $LANG="francais" ]
then
	echo "\usepackage[T1]{fontenc}
" >> ${FILE}
fi

# Tables
echo "
% Tables
\usepackage{array}
\usepackage{longtable}
" >> ${FILE}

# Hyperrefferences
echo "
% Hyperrefferences  
\usepackage{hyperref}
" >> ${FILE}

# Font setting
if [ $FONT != "default" ]
then
    echo "
% Font settings:
\usepackage{$FONT}
" >> ${FILE}
fi

# Page layout settings
echo "
\title{${TITLE}}
\author{${AUTHOR}}
% Page layout settings
\usepackage{geometry}
\geometry{
	a4paper,  % 21 x 29,7 cm
	body={160mm,240mm},
	left=30mm, 
	top=25mm,
	headheight=7mm, 
	headsep=4mm,
	marginparsep=4mm,
	marginparwidth=27mm
}
" >> $FILE

## Listings
#echo "
#% Listings
#\usepackage{minted}
#" >> $FILE

# Spacing
echo "
% Spacing:
\usepackage{setspace}
" >> $FILE

# Headers and footers
# bas-droite/basgauche: page
# milieu: auteur+titre
echo "
% Headers and footers:
\usepackage{fancyhdr}
\pagestyle{fancy}
          \fancyhf{}
          \fancyfoot[LE,RO]{\textcolor[gray]{0.3}{\thepage}}
          % Rulers width
          \renewcommand{\footrulewidth}{$FRULE}
          \renewcommand{\headrulewidth}{$HRULE}
\fancyfoot[LO,RE]{\textcolor[gray]{0.3}{$AUTHOR}}
\fancyfoot[CO,CE]{\textcolor[gray]{0.3}{$TITLE}}
" >> ${FILE}

# (Re)define stuff
echo "
% Vars & functs
% Paths
\newcommand\PIXPATH{$PIXPATH}
\newcommand\SRCPATH{$SRCPATH}

% Object:
\newcommand\Object{$OBJECT}

% End of line(forced):
\newcommand\el{\hfill\\\}

% Lists design:
\renewcommand{\labelitemi}{$\diamond$}
\renewcommand{\labelenumii}{\arabic{enumi}.\arabic{enumii}}
" >> ${FILE}

# Begining of document
echo "
% Begining of the document
\begin{document}
" >> ${FILE}

# Main part
	echo "	%Including all the files:" >> $FILE
for i in `ls ${TEXPATH}/*.tex`
do
	echo "
    % Fichier $i
" >> $FILE

	# We want the file in the good encoding.
    if [ `file -i "$i" | grep $CENC | wc -l` == 1 ]
    then
        cat "$i" >> $FILE
        echo "File $i included"
    else
	    iconv -f$BADENC -t$CENC "$i" >> $FILE
        echo "File $i converted from $BADENC to $CENC and included"
    fi
done

# End of document
echo "
% The end
\end{document}
" >> ${FILE}
