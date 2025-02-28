#import "locale.typ": ACRONYMS
#import "shared-lib.typ": display, display-link, assert-in-dict
#import "custom-outline-entry-formatting.typ": *

#let prefix = "acronym-state-"
#let acros = state("acronyms", none)
#let link-to-toc = state("link-acros-to-toc", true)

/// Initialize the acronym. \
/// This will set the dictionary containing all acronyms and define, if they should be linked to the @print-acronyms.
#let init-acronyms(
  /// Dicttionary containing all acronyms.
  /// See #link(<AcroDefacronyms>, "Define Aconyms") for more information.
  /// -> dictionary
  acronyms,
  /// Creates links the output of @print-acronyms.
  link-acros-to-toc,
) = {
  acros.update(acronyms)
  link-to-toc.update(link-acros-to-toc)
}

/// Display an acronym in the short form
/// ```example
/// Short form: #acs("SPS")
/// ```
/// -> str
#let acs(
  /// Acronym key -> str
  acr,
  /// Display the plural form-> bool
  plural: false,
) = {
  context {
    let link = link-to-toc.get()
    let acronyms = acros.get()

    assert-in-dict("acronyms", acros, acr)
    let defs = acronyms.at(acr)

    if type(defs) == str {
      if plural {
        display("acronyms", acros, acr, acr + "s", link: link)
      } else {
        display("acronyms", acros, acr, acr, link: link)
      }
    } else if type(defs) == array {
      if defs.len() == 0 {
        panic(
          "No definitions found for acronym "
            + acr
            + ". Make sure it is defined in the dictionary passed to #init-acronyms(dict)",
        )
      }
      if plural {
        if defs.len() == 1 {
          display("acronyms", acros, acr, acr + "s", link: link)
        } else if defs.len() == 2 {
          display("acronyms", acros, acr, defs.at(1).at(0), link: link)
        }
      } else {
        if defs.len() == 1 {
          display("acronyms", acros, acr, acr, link: link)
        } else if defs.len() == 2 {
          display("acronyms", acros, acr, defs.at(0).at(0), link: link)
        }
      }
    } else {
      panic("Definitions should be arrays of one or two strings. Definition of " + acr + " is: " + type(defs))
    }
  }
}

/// Display an acronym in the short-plural form
/// ```example
/// Short plural form: #acspl("SPS")
/// ```
/// -> str
#let acspl(
  /// Acronym key -> str
  acr,
) = {
  acs(acr, plural: true)
}

/// Display an acronym in the long form.
/// ```example
/// Long form: \
/// #acl("SPS")
/// ```
/// -> str
#let acl(
  /// Acronym key -> str
  acr,
  /// Display the plural form -> bool
  plural: false,
) = {
  context {
    let link = link-to-toc.get()
    let acronyms = acros.get()

    assert-in-dict("acronyms", acros, acr)
    let defs = acronyms.at(acr)
    // Type is string -> plural will add "s"
    if type(defs) == str {
      if plural {
        display("acronyms", acros, acr, defs + "s", link: link)
      } else {
        display("acronyms", acros, acr, defs, link: link)
      }
    } // Type is array -> plural possibly provided
    else if type(defs) == array {
      if defs.len() == 0 {
        panic(
          "No definitions found for acronym "
            + acr
            + ". Make sure it is defined in the dictionary passed to #init-acronyms(dict)",
        )
      }
      if plural {
        // Array but length 1 -> no plural provided, add "s"
        if defs.len() == 1 {
          display("acronyms", acros, acr, defs.at(0) + "s", link: link)
        } // Length is 2 -> plural provided
        else if defs.len() == 2 {
          display("acronyms", acros, acr, defs.at(1).at(1), link: link)
        } else {
          panic("Definitions should be arrays of one or two strings. Definition of " + acr + " is: " + type(defs))
        }
      } /// Plural not requested
      else {
        if defs.len() == 1 {
          display("acronyms", acros, acr, defs.at(0), link: link)
        } else if defs.len() == 2 {
          display("acronyms", acros, acr, defs.at(0).at(1), link: link)
        }
      }
    } else {
      panic("Definitions should be arrays of one or two strings. Definition of " + acr + " is: " + type(defs))
    }
  }
}

/// Display an acronym in the long plural form.
/// ```example
/// Long plural form: \
/// #aclpl("SPS")
/// ```
/// -> str
#let aclpl(
  /// Acronym key -> str
  acr,
) = {
  acl(
    acr,
    plural: true,
  )
}

/// Display an acronym as if it is shown for the first time.
/// ```example
/// As shown for the first time: \
/// #acf("SPS")
/// ```
/// -> str
#let acf(
  /// Acronym key -> str
  acr,
  /// Display the plural form -> bool
  plural: false,
) = {
  context {
    let link = link-to-toc.get()
    if plural {
      display("acronyms", acros, acr, [#aclpl(acr) (#acr\s)], link: link)
    } else {
      display("acronyms", acros, acr, [#acl(acr) (#acr)], link: link)
    }
    state(prefix + acr, false).update(true)
  }
}

/// Display an acronym in the long plural form as if it is shown for the first time.
/// ```example
/// Long plural, as shown for the first time: \
/// #acfpl("SPS")
/// ```
/// -> str
#let acfpl(
  /// Acronym key -> str
  acr,
) = {
  acf(acr, plural: true)
}

#let ac(acr, plural: false) = {
  context {
    let seen = state(prefix + acr, false).get()

    if seen {
      if plural {
        acspl(acr)
      } else {
        acs(acr)
      }
    } else {
      if plural {
        acfpl(acr)
      } else {
        acf(acr)
      }
    }
  }
}

/// Display an acronym in the plural form.
/// ```example
/// Plural form: #acpl("SPS")
/// ```
/// -> str
#let acpl(acronym) = {
  ac(acronym, plural: true)
}

/// Print all used acronyms in a outline. \
/// Using this with `link-to-toc` true, will couse all acronyms to be linked to here.
/// -> content
#let print-acronyms(
  /// Language to be used -> str
  language,
  /// Font to be used -> str
  font,
  /// Height of a single entry (line) -> length
  entry-height,
) = {
  heading(level: 1, outlined: true)[#ACRONYMS.at(language)]

  context {
    let acronyms = acros.get()
    let acronym-keys = acronyms.keys()

    let max-width = 0pt
    for acr in acronym-keys {
      let result = measure(acr).width

      if (result > max-width) {
        max-width = result
      }
    }

    let acr-list = acronym-keys.sorted()

    for acr in acr-list {
      set text(font: font)
      custom-outline-entry-formatting(
        location: none,
        front: [*#acr#label("acronyms-" + acr)*],
        mid: [#acl(acr)],
        front-max-width: max-width,
        entry-height: entry-height,
      )
    }
  }
}
