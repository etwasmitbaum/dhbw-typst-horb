// LTeX: enabled=false
// The formatting for custom outlines

// Set vertical spacing is set by par(leading: value)
// Since this is context depended it must be set when calling this function
#let custom-outline-entry-formatting(
  location: none, // Location, label, etc. to the content
  front: none,  // Content of the front, ex: "Figure 2.4"
  mid: none,  // Conecten in the mid part, ex: "This is a Cat"
  back: none, // Content at the end, ex: page number "4"
  row-extra-spacing: 0em, // space between two entries
  front-max-width: 1fr,  // Maximum width of the front part
  spacing-after-front: 3em  // The space inserted after front-max-width. If front-max-width is a fraction, this has no effect
  ) = {

    // Add extra space when front-max-width is not a fraction
    if type(front-max-width) != fraction {
      front-max-width = front-max-width + 3em
    }
    
    if location == none {
      box([#front], width: front-max-width)
      box([#mid], width: 4fr)
      box([#back], width: auto)
    } else {
      box({link(location, [#front])}, width: front-max-width)
      box({link(location, [#mid])}, width: 4fr)
      box({link(location, [#back])}, width: auto)
    }
    
}