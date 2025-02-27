#import "@preview/tidy:0.4.1"
#import "../includes/ToDo.typ"
#import "../includes/custom-equation.typ"

#show outline.entry.where(level: 1): level1 => [
  #set text(weight: "bold", size: 1em)
  #set block(above: 1.5em)
  #level1
]

#outline(depth: 3)
#pagebreak(weak: true)

// Modify heading after outline
#show heading.where(level: 2): level2 => [
  // Add sapce aboce, so it doesn't look so tight
  #v(3em)
  #level2
]

#show heading.where(level: 1): level1 => [
  #level1
  // Remove the space added level2 space
  #v(-2em, weak: true)
]

// Change the equation numbering for the preview. The chapter number is static, else "0" would be displayed
#set math.equation(
  numbering: (..num) => {
    numbering("(1.1)", 2, num.pos().first())
  },
)

= Public functions

// clean-dhbw
#let clean-dhbw-docs = tidy.parse-module(read("../lib.typ"), name: "Clean DHWB")
#tidy.show-module(clean-dhbw-docs, style: tidy.styles.default)

// equations
#let custom-equation-docs = tidy.parse-module(
  read("../includes/custom-equation.typ"),
  name: "Custom equations",
  scope: (custom-equation: custom-equation),
  preamble: "#import custom-equation: *\n",
)
#tidy.show-module(custom-equation-docs, style: tidy.styles.default)

// ToDo
#let todo-docs = tidy.parse-module(
  read("../includes/todo.typ"),
  name: "ToDo",
  scope: (ToDo: ToDo),
  preamble: "#import ToDo: *\n",
)
#tidy.show-module(todo-docs, style: tidy.styles.default)

#pagebreak()
= Internal functions

// custom outline entry
#let custom-outline-entry-formatting-docs = tidy.parse-module(
  read("../includes/custom-outline-entry-formatting.typ"),
  name: "Custom outline Entry",
)
#tidy.show-module(custom-outline-entry-formatting-docs, style: tidy.styles.default)
