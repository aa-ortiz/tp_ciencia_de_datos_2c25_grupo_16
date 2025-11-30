############################################################
# 05_impacto_limpieza.R
# Evaluación del impacto de la limpieza
############################################################

library(dplyr)
library(tidyr)

# 1) Cargar bases ------------------------------------------

base_raw     <- readRDS("data/raw/eph_t3_2024_raw.rds")
base_limpia  <- readRDS("data/clean/eph_t3_2024_limpia.rds")
base_modelo  <- readRDS("data/clean/eph_t3_2024_modelo.rds")

# 2) Tamaño muestral ----------------------------------------

n_raw    <- nrow(base_raw)
n_limpia <- nrow(base_limpia)
n_modelo <- nrow(base_modelo)

df_sizes <- data.frame(
  etapa = c("Raw", "Limpia", "Modelo"),
  n_obs = c(n_raw, n_limpia, n_modelo)
)

df_sizes

write.csv(df_sizes,
          "data/clean/impacto_limpieza_nobs.csv",
          row.names = FALSE)


# 3) Distribución de sexo antes/después ----------------------

dist_sexo_raw <- base_raw %>%
  mutate(sexo = ifelse(CH04 == 1, "Varón",
                       ifelse(CH04 == 2, "Mujer", NA))) %>%
  count(sexo, name = "n_raw")

dist_sexo_modelo <- base_modelo %>%
  count(sexo, name = "n_modelo")

dist_sexo <- full_join(dist_sexo_raw, dist_sexo_modelo, by = "sexo") %>%
  mutate(
    diff_abs = n_modelo - n_raw,
    diff_pct = (n_modelo - n_raw) / n_raw * 100
  )

dist_sexo

write.csv(dist_sexo,
          "data/clean/impacto_limpieza_sexo.csv",
          row.names = FALSE)


# 4) Distribución educativa antes/después --------------------

dist_edu_raw <- base_raw %>%
  count(NIVEL_ED, name = "n_raw")

dist_edu_modelo <- base_modelo %>%
  count(educ_grupo, name = "n_modelo")

# NOTA: No se puede mapear 1 a 1 porque las escalas son distintas,
# pero sirve para mostrar cambios en cantidad.

write.csv(dist_edu_modelo,
          "data/clean/impacto_limpieza_educacion.csv",
          row.names = FALSE)


# 5) Informalidad antes/después ------------------------------

# En RAW no existe informalidad aún → no se compara
# Pero sí comparamos LÍMPIA vs MODELO

dist_inf_limpia <- base_limpia %>%
  count(informal, name = "n_limpia")

dist_inf_modelo <- base_modelo %>%
  count(informal, name = "n_modelo")

impacto_inf <- full_join(dist_inf_limpia, dist_inf_modelo,
                         by = "informal") %>%
  mutate(
    diff_abs = n_modelo - n_limpia,
    diff_pct = (n_modelo - n_limpia) / n_limpia * 100
  )

impacto_inf

write.csv(impacto_inf,
          "data/clean/impacto_limpieza_informalidad.csv",
          row.names = FALSE)


# 6) Edad antes/después --------------------------------------

edad_raw_summary <- summary(base_raw$CH06)
edad_modelo_summary <- summary(base_modelo$edad)

edad_raw_summary
edad_modelo_summary

############################################################
# FIN 05_impacto_limpieza.R
############################################################
