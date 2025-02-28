/// Dictionary containing all acronym with their short and long form. \
/// Optional provide the plural form of the short and long versions. \
/// If no plural is provided, `s` will be appended. \
/// Exmaple: \
/// #raw("
/// #let acronyms = (
///   // Only singular provided, for plural \"s\" will be appended.
///   API: \"Application Programming Interface\",
/// 
///   // Singular and plural are provided, with each short and long form. 
///   SPS: ((\"SPS\", \"Speicherprogrammierbare Steuerung\"), (\"SPSen\", \"Speicherprogrammierbare Steuerungen\")
/// )",
/// lang: "typ")
#let acronyms = (
  API: "Application Programming Interface",
  HTTP: ("Hypertext Transfer Protocol",), // make this an array of length 1, for testing
  REST: "Representational State Transfer",
  SPS: (("SPS", "Speicherprogrammierbare Steuerung"), ("SPSen", "Speicherprogrammierbare Steuerungen")),
)
