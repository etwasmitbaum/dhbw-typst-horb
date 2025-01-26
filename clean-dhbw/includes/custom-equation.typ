#import "locale.typ": EQUATION

// ---- Custom wrapper for equations ----
#let outlined-equations = state("outlined-equations-key", (:))

#let equation(body, caption: none, label: none) = {
  if label != none and caption != none {
    outlined-equations.update(it => {
      it.insert(str(label), (label, caption))
      it
    })
  }

  if label == none and caption != none {
    panic("You must set a label if a caption is provided!")
  }
  
  [
    #body
    #label
  ]
}

