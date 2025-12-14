_default: 
   @just -l

# link local packages into your Racket installation
install: 
   raco pkg install --auto --skip-installed --link ./stlc-lib ./stlc-test ./stlc-doc ./stlc

# compile the linked packages
setup: 
   raco setup --pkgs stlc-lib stlc-test

# run the test suite
test: 
   raco test stlc-test/tests/stlc/

# build documentation as single-page HTML
doc: 
   raco scribble --html --dest doc --dest-name index stlc-doc/scribblings/stlc/main.scrbl

# open the documentation page
preview:
   open ./doc/index.html
