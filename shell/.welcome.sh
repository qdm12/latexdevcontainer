echo "TexLive release $(tlmgr version | tail -n 1 | cut -f5- -d' ')"
echo "tlmgr version $(tlmgr version | head -n 1 | cut -f3- -d' ')"
echo "latexindent version $(latexindent --version)"
echo "latexmk version $(latexmk -version | tail -n 1 | cut -f8 -d' ')"
echo "Useful commands available:"
echo " * Update LaTex packages: tlmgr update --all"
echo " * Install a LaTex package:"
echo "       tlmgr install packagename"
echo "       texhash"
echo " * Install an OS package: sudo apt-get install -y packagename"
