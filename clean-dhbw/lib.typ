
// LTeX: enabled=false
#import "@preview/codelst:2.0.2": *
#import "@preview/hydra:0.5.1": hydra
#import "includes/acronym-lib.typ": init-acronyms, print-acronyms, acr, acrpl, acrs, acrspl, acrl, acrlpl, acrf, acrfpl
#import "includes/glossary-lib.typ": init-glossary, print-glossary, gls
#import "includes/locale.typ": TABLE_OF_CONTENTS, APPENDIX, REFERENCES
#import "includes/titlepage.typ": *
#import "includes/confidentiality-statement.typ": *
#import "includes/declaration-of-authorship.typ": *
#import "includes/check-attributes.typ": *
#import "includes/custom-equation.typ"
#import "includes/custom-outline-entry-formatting.typ": *
#import "includes/ToDo.typ": *

// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography

#let clean-dhbw(
  title: none,
  authors: (:),
  language: none,
  at-university: none,
  confidentiality-marker: (display: false),
  type-of-thesis: none,
  show-confidentiality-statement: true,
  show-declaration-of-authorship: true,
  show-table-of-contents: true,
  show-table-of-images: true,
  show-table-of-tables: true,
  show-table-of-code: true,
  show-table-of-equations: true,
  show-acronyms: true,
  show-abstract: true,
  glossary-spacing: 1.5em,
  outline-number-title-spacing: 1em,
  abstract: none,
  abstract-second-language: none,
  second-language-for-abstract: none,
  appendix: none,
  acronyms: none,
  glossary: none,
  confidentiality-statement-content: none,
  declaration-of-authorship-content: none,
  titlepage-content: none,
  university: none,
  university-location: none,
  university-short: none,
  city: none,
  supervisor: (:),
  date: none,
  date-format: "[day].[month].[year]",
  bibliography: none,
  bib-style: "ieee",
  math-numbering: "(1)",
  logo-left: image("img/general/firmenlogo.png"),
  logo-right: image("img/general/dhbw.svg"),
  ignored-link-label-keys-for-highlighting: (),
  body,
) = {
  // check required attributes
  check-attributes(
    title,
    authors,
    language,
    at-university,
    confidentiality-marker,
    type-of-thesis,
    show-confidentiality-statement,
    show-declaration-of-authorship,
    show-table-of-contents,
    show-acronyms,
    show-abstract,
    glossary-spacing,
    abstract,
    appendix,
    acronyms,
    university,
    university-location,
    supervisor,
    date,
    city,
    bibliography,
    bib-style,
    logo-left,
    logo-right,
    university-short,
    math-numbering,
    ignored-link-label-keys-for-highlighting,
  )

  // ---------- Fonts & Related Measures ---------------------------------------

  let body-font = "Times New Roman"
  let body-size = 11pt
  let heading-font = "Arial"
  let h1-size = 40pt
  let h2-size = 16pt
  let h3-size = 11pt
  let h4-size = 11pt
  let page-grid = 16pt // vertical spacing on all pages


  // ---------- Basic Document Settings ---------------------------------------

  set document(title: title, author: authors.map(author => author.name))
  let many-authors = authors.len() > 3
  let in-frontmatter = state("in-frontmatter", true) // to control page number format in frontmatter
  let in-body = state("in-body", true) // to control heading formatting in/outside of body

  init-acronyms(acronyms)
  init-glossary(glossary)

  // Change the citation style
  set cite(style: "alphanumeric")

  // customize look of figure
  set figure.caption(separator: [ --- ], position: bottom)
  // change "listing" to "code"
  show figure.where(kind: raw): set figure(supplement: CODE.at(language))

  // Figure number will start with chapter number
  set figure(
    numbering: (..num) => {
      numbering("1.1", counter(heading).get().first(), num.pos().first())
    },
  )

  // math numbering
  set math.equation(
    numbering: (..num) => {
      numbering("(1.1)", counter(heading).get().first(), num.pos().first())
    },
  )

  // set link style for links that are not acronyms
  let acronym-keys = if (acronyms != none) {
    acronyms.keys().map(acr => ("acronyms-" + acr))
  } else {
    ()
  }
  let glossary-keys = if (glossary != none) {
    glossary.keys().map(gls => ("glossary-" + gls))
  } else {
    ()
  }
  // Make all Links black
  //  show link: it => {
  //    // When calling link with a location it errors because str(it.dest) expects different types
  //    if type(it.dest) != location {
  //      if (str(it.dest) not in (acronym-keys + glossary-keys + ignored-link-label-keys-for-highlighting)) {
  //        text(fill: blue, it)
  //      }
  //    } else {
  //      it
  //    }
  //  }

  // ========== TITLEPAGE ========================================

  if (titlepage-content != none) {
    titlepage-content
  } else {
    titlepage(
      authors,
      date,
      heading-font,
      language,
      logo-left,
      logo-right,
      many-authors,
      supervisor,
      title,
      type-of-thesis,
      university,
      university-location,
      at-university,
      date-format,
      show-confidentiality-statement,
      confidentiality-marker,
      university-short,
      page-grid,
    )
  }
  counter(page).update(1)

  // ---------- Page Setup ---------------------------------------

  // adapt body text layout to basic measures
  set text(
    font: body-font,
    lang: language,
    size: body-size - 0.5pt, // 0.5pt adjustment because of large x-hight
    top-edge: 0.75 * body-size,
    bottom-edge: -0.25 * body-size,
  )
  set par(
    spacing: page-grid,
    leading: page-grid - body-size,
    justify: true,
  )

  set page(
    margin: (top: 2.5cm, bottom: 3.1cm, left: 2.5cm, right: 2.5cm),
    // Header
    header: grid(
      columns: (1fr, 1fr, 1fr),
      align: (left, center, right),
      row-gutter: 0.5em,
      box(logo-left, height: 2 * page-grid),
      smallcaps(
        text(
          font: heading-font,
          size: body-size,
          context {
            hydra(1, display: (_, it) => it.body, use-last: true, skip-starting: false)
          },
        ),
      ),
      box(logo-right, height: 2 * page-grid),
      grid.cell(colspan: 3, line(length: 100%, stroke: 0.5pt)),
    ),
    header-ascent: page-grid,
    // Footer
    footer: // also use grid here, to make it easily extendable
    grid(
      columns: 1fr,
      align: (right),
      row-gutter: 0.5em,
      grid.cell(colspan: 1, line(length: 100%, stroke: 0.5pt)),
      text(
        font: heading-font,
        size: body-size,
        number-type: "lining",
        context {
          if in-frontmatter.get() {
            counter(page).display("I") // roman page numbers for the   frontmatter
          } else {
            counter(page).display("1") // arabic page numbers for the  rest of the document
          }
        },
      ),
    ),
    footer-descent: page-grid,
    numbering: (..number) => {
      // Change numbering so it also shows correctly in the outline
      if in-frontmatter.get() {
        numbering("I", ..number)
      } else {
        numbering("1", ..number)
      }
    },
  )


  // ========== FRONTMATTER ========================================

  // ---------- Heading Format (Part I) ---------------------------------------

  show heading: set text(weight: "bold", font: heading-font)
  show heading.where(level: 1): it => { v(2 * page-grid) + text(size: 2 * page-grid, it) + v(0.8em) }
  show outline: set heading(outlined: true)

  // ========== LEGAL BACKMATTER ========================================

  // ---------- Confidentiality Statement ---------------------------------------

  if (not at-university and show-confidentiality-statement) {
    confidentiality-statement(
      authors,
      title,
      confidentiality-statement-content,
      university,
      university-location,
      date,
      language,
      many-authors,
      date-format,
    )
  }

  // ---------- Declaration Of Authorship ---------------------------------------

  if (show-declaration-of-authorship) {
    declaration-of-authorship(
      authors,
      title,
      type-of-thesis,
      declaration-of-authorship-content,
      date,
      language,
      many-authors,
      at-university,
      city,
      date-format,
    )
  }
  // ---------- Abstract ---------------------------------------

  if (show-abstract and abstract != none) {
    heading(level: 1, numbering: none, outlined: false, ABSTRACT.at(language))
    text(abstract)

    if (second-language-for-abstract != none and abstract-second-language != none) {
      pagebreak(weak: true)
      heading(level: 1, numbering: none, outlined: false, ABSTRACT.at(second-language-for-abstract))
      text(abstract-second-language)
    }

    pagebreak()
  }

  // ---------- Outline ---------------------------------------

  // top-level TOC entries in bold without filling
  show outline.entry.where(level: 1): level1 => {
    // set block heigt for all level1 entries to 1em, so equaitons and figures have the same default height
    set block(height: 1em)
    // Modify the display of heading in the outline
    if (level1.element.func() == heading) {
      set block(above: page-grid)
      set text(font: heading-font, weight: "semibold", size: body-size)
      link(
        level1.element.location(),
        {
        level1.indented(
          gap: outline-number-title-spacing,
          level1.prefix(),
          {
            level1.body()
            box(width: 1fr)
            text(weight: "semibold", level1.page())
          }
        )
        },
      )
    } // Figure types are list of tables etc. So there level 1 look is different
    else if (level1.element.func() == figure) {
      set text(font: heading-font, size: body-size)

      context{
        // if the counter is one, it must be the first element of its chapter, therefore insert a bit of space
        // the same is used below for equations
        let count = level1.element.counter.at(level1.element.location())
        if count.first() == 1 {
          v(1em)
        }
      }
      
      level1.indented(
        [],
        {
          custom-outline-entry-formatting(
            location: level1.element.location(),
            front: level1.prefix(),
            mid: level1.body(),
            back: level1.page()
          )
        }
      )
    
    }
    // Fallback: Default outline
    else {
      level1
    }
  }


  // other TOC entries in regular with adapted filling
  show outline.entry.where(level: 2): level2 => {
    set text(font: heading-font, size: body-size)
    link(
      level2.element.location(),
      level2.indented(
        gap: outline-number-title-spacing,
        level2.prefix(),
        {
          level2.body()
          box(width: 1fr, align(right, repeat([.], gap: .4em, justify: false)), baseline: 30%, height: body-size + 1pt)
          level2.page()
        }
      ))
  }

  show outline.entry.where(level: 3): level3 => {
    set text(font: heading-font, size: body-size)
    link(
      level3.element.location(),
      level3.indented(
        gap: outline-number-title-spacing,
        level3.prefix(),
        {
          level3.body()
          h(1em)
          box(width: 1fr, align(right, repeat([.], gap: .4em, justify: false)), baseline: 30%, height: body-size + 1pt)
          h(1em)
          level3.page()
        }
      )
    )
  }


  if (show-table-of-contents) {
    outline(
      title: TABLE_OF_CONTENTS.at(language),
      indent: auto,
      depth: 3,
    )
  }

  pagebreak(weak: true)

  // Table of figures
  if show-table-of-images {
    outline(
      title: TABLE_OF_FIGURES.at(language),
      target: figure.where(kind: image),
    )
    pagebreak(weak: true)
  }

  // Table of tables
  if show-table-of-tables {
    outline(
      title: TABLE_OF_TABLES.at(language),
      target: figure.where(kind: table),
    )
    pagebreak(weak: true)
  }


  // Table of code
  if show-table-of-code {
    outline(
      title: TABLE_OF_CODE.at(language),
      target: figure.where(kind: raw), // kind ist raw, since codelst wraps around it (see docs of codelst)
    )
    pagebreak(weak: true)
  }


  // Table of equations
  if show-table-of-equations {
    heading(TABLE_OF_EQUATIONS.at(language))
    context {
      set text(font: heading-font, size: body-size)
      for (_, (label, caption)) in custom-equation.outlined-equations.final() {
        let page = counter(page).at(label).first()

        // if the counter is one, it must be the first element of its chapter, therefore insert a bit of space
        // the same is used above for figures etc
        let count = counter(math.equation).at(label)
        if count.first() == 1 {
          v(0em)  // i dont know why it needs 0em, but this makes the spacing correct
        }

        context custom-outline-entry-formatting(
          location: label,
          front: ref(label),
          mid: caption,
          back: page,
        )
      }
    }
    pagebreak(weak: true)
  }


  // Acronym
  if (show-acronyms and acronyms != none and acronyms.len() > 0) {
    print-acronyms(language, heading-font) // Should be same font as other oulines
  }

  pagebreak(weak: true) // this is needed so the footer display the correct page number (else 0 or n would be displayed)

  in-frontmatter.update(false) // end of frontmatter
  counter(page).update(1) // so the first chapter starts at page 1 (now in arabic numbers)

  // ========== DOCUMENT BODY ========================================

  // ---------- Heading Format (Part II: H1-H4) ---------------------------------------

  set heading(numbering: "1.1.1")

  show heading: it => {
    set par(leading: 4pt, justify: false)
    text(it, top-edge: 0.75em, bottom-edge: -0.25em)
    v(page-grid, weak: true)
  }

  show heading.where(level: 1): it => {
    set par(leading: 0pt, justify: false)
    pagebreak()
    // Reset the counter after level 1 heading, so they start from 1 again
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: raw)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)

    context {
      v(2 * page-grid)
      text(
        size: 2 * page-grid,
        counter(heading).display() + h(0.5em) + it.body,
        top-edge: 0.5em,
        bottom-edge: -0.5em, // move text further down
      )
    }
  }

  show heading.where(level: 2): it => { v(16pt) + text(size: h2-size, it) }
  show heading.where(level: 3): it => { v(16pt) + text(size: h3-size, it) }
  show heading.where(level: 4): it => { v(16pt) + smallcaps(text(size: h4-size, weight: "semibold", it.body)) }

  // ---------- Body Text ---------------------------------------

  body

  // ========== APPENDIX =======================================

  in-body.update(false)
  set heading(numbering: "A.1")
  counter(heading).update(0)

  // ---------- Bibliography ---------------------------------------

  show std-bibliography: set heading(numbering: "A.1")
  if bibliography != none {
    set std-bibliography(
      title: REFERENCES.at(language),
      style: bib-style,
    )
    bibliography
  }

  // ---------- Glossary ---------------------------------------

  if (glossary != none and glossary.len() > 0) {
    print-glossary(language, glossary-spacing)
  }

  // ---------- Appendix (other contents) ---------------------------------------

  if (appendix != none) {
    // the user has to provide heading(s)
    heading(level: 1)[#APPENDIX.at(language)]
    appendix
  }
}

// Eqation command for main.typ
#let equation = custom-equation.equation
#let todo = todo