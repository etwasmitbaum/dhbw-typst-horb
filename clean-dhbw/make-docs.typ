#import "@preview/tidy:0.4.1"

#let docs = tidy.parse-module(read("lib.typ"))
#tidy.show-module(docs, style: tidy.styles.default)