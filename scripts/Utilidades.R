# ==============================================================================
# Funciones utilitarias para utilizar en otros scripts.
# 
# ==============================================================================


h <- function(texto) {
  cat(sprintf("\n-- %s --\n", toupper(texto)))
}

cat0 <- function(...) cat(..., sep = "")

exportar_tabla <- function(tabla, path = NULL, caption) {
  tabla_kbl <- tabla %>%
    kbl(
      caption = caption,
      align = "c",
      row.names = FALSE,
      escape = FALSE,
      label = NA
    ) %>%
    kable_styling(
      bootstrap_options = c("striped", "hover", "condensed"),
      full_width = FALSE,
      position = "center"
    ) %>%
    row_spec(0, bold = TRUE, background = "#5C068C", color = "white")
  
  if (!is.null(path)) {
    cat0("\nGuardando resultado PNG, espere un momento...")
    save_kable(tabla_kbl, file = path, zoom = 2)
    cat("Se ha generado el fichero: ", path, "\n")
  }
  
  return(tabla_kbl)
}
