############################################################
# 02_outliers_faltantes.R
# Análisis de datos faltantes y outliers básicos
############################################################

library(dplyr)

# 1) Cargar base limpia ------------------------------------
base_limpia <- readRDS("data/clean/eph_t3_2024_limpia.rds")

# 2) Resumen de NAs por variable ---------------------------
na_resumen <- base_limpia %>%
  summarise(across(everything(),
                   ~ sum(is.na(.)),
                   .names = "na_{.col}")) %>%
  tidyr::pivot_longer(everything(),
                      names_to = "variable",
                      values_to = "n_na") %>%
  arrange(desc(n_na))

na_resumen

# Guardamos tabla de NAs (para usar en el informe)
write.csv(na_resumen,
          "data/clean/resumen_NA_eph_t3_2024.csv",
          row.names = FALSE)

# 3) Chequear distribución de edad (posibles outliers) -----
summary(base_limpia$edad)
# hist(base_limpia$edad)  # si querés ver el histograma

# Como ya filtramos 18–64 en el script 01,
# no deberíamos tener outliers "raros" de edad.

# 4) Decisión sobre faltantes en variables clave ----------
# Nos importan especialmente: informal, educ_grupo, sexo, edad
# Vamos a eliminar filas con NA en cualquiera de esas cuatro.

base_modelo <- base_limpia %>%
  filter(
    !is.na(informal),
    !is.na(educ_grupo),
    !is.na(sexo),
    !is.na(edad)
  )

# Comparar tamaños antes y después (para el informe)
nrow(base_limpia)
nrow(base_modelo)

# 5) Guardar base lista para análisis/modelo ---------------
saveRDS(base_modelo, "data/clean/eph_t3_2024_modelo.rds")
write.csv(base_modelo,
          "data/clean/eph_t3_2024_modelo.csv",
          row.names = FALSE)

############################################################
# Fin 02_outliers_faltantes.R
############################################################
