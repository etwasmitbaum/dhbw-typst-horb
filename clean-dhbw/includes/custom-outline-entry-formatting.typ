
// LTeX: enabled=false
// The formatting for custom outlines

/// This function create one line seperated into `front`, `mid`, and `back`. It is intended to be used as a custom ouline entry.
#let custom-outline-entry-formatting(
  /// The location of the content, none will create no link. -> dictionary | label | location | ref-label | str
  location: none,
  /// Content of the front part, eg. "Figure 2.4". -> content
  front: none,
  /// Content of the middle part eg. "This image shows a Cat". -> content
  mid: none,
  /// Content of the end, will be most to the right. Eg. the page number "4". -> content
  back: none,
  /// Maximum width of all front entries, this is used so all front parts have the same width and the mid parts are aligned. -> length | fraction
  front-max-width: 1fr,
  /// The space inserted after front-max-width. If front-max-width is a fraction, this has no effect. -> length
  spacing-after-front: 3em,
  /// The height of a single line (entry). -> length
  entry-height: 1em,
) = {
  // Add extra space when front-max-width is not a fraction
  if type(front-max-width) != fraction {
    front-max-width = front-max-width + 3em
  }

  box(
    height: entry-height,
    if location == none {
      // wrap box with extra height around to create spacing
      box([#front], width: front-max-width)
      box([#mid], width: 4fr)
      box([#back], width: auto)
    } else {
      // wrap box with extra height around to create spacing
      box({ link(location, [#front]) }, width: front-max-width)
      box({ link(location, [#mid]) }, width: 4fr)
      box({ link(location, [#back]) }, width: auto)
    },
  )
}
