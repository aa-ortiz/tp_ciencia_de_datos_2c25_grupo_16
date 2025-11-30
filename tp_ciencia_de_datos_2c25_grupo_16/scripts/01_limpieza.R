############################################################
# 01_limpieza.R
# Limpieza inicial EPH T3 2024
############################################################

# 0) Paquetes -----------------------------------------------------------
library(dplyr)

# 1) Cargar base cruda --------------------------------------------------
# Acá supongo que YA tenés eph_t3_2024 en el entorno
# (por haberla bajado con eph::get_microdata o importado a mano).
# Si en el futuro la querés leer desde un archivo, podrías hacer:
# eph_t3_2024 <- readRDS("data/raw/eph_t3_2024_raw.rds")

base_raw <- eph_t3_2024   # copia de trabajo

# 2) Crear carpetas del proyecto (si no existen) ------------------------
dir.create("data", showWarnings = FALSE)
dir.create("data/raw", showWarnings = FALSE)
dir.create("data/clean", showWarnings = FALSE)

# Guardamos una copia cruda por las dudas
saveRDS(base_raw, "data/raw/eph_t3_2024_raw.rds")

# 3) Nos quedamos solo con las variables que vamos a necesitar ----------
# Si alguna columna no existe con ese nombre, R va a tirar error.
# En ese caso, solo hay que cambiar el nombre en este select.

base_sel <- base_raw %>%
  select(
    CODUSU, NRO_HOGAR, COMPONENTE,   # identificación
    ANO4, TRIMESTRE,                 # año y trimestre
    CH04, CH06,                      # sexo, edad
    NIVEL_ED,                        # nivel educativo
    PP07H,                           # aporta jubilación (formalidad)
    ESTADO,                          # condición de actividad
    AGLOMERADO                       # región / aglomerado
  )

# (Opcional) Mirar cómo son ESTADO y PP07H para chequear códigos
# table(base_sel$ESTADO, useNA = "ifany")
# table(base_sel$PP07H,  useNA = "ifany")

# 4) Filtrar población objetivo ----------------------------------------
# Suposición estándar de EPH:
# ESTADO: 1 = Ocupado, 2 = Desocupado, 3 = Inactivo
# Si vieras otros códigos, avisá y lo ajustamos.

base_filtrada <- base_sel %>%
  filter(
    CH06 >= 18,
    CH06 <= 64,
    ESTADO == 1           # nos quedamos solo con ocupados
  )

# 5) Crear variables limpias -------------------------------------------

base_limpia <- base_filtrada %>%
  mutate(
    # Sexo como texto
    sexo = ifelse(CH04 == 1, "Varón",
                  ifelse(CH04 == 2, "Mujer", NA_character_)),
    
    # Informalidad: 1 = informal (no aporta), 0 = formal (aporta)
    informal = case_when(
      PP07H == 2 ~ 1,   # no aporta → informal
      PP07H == 1 ~ 0,   # sí aporta → formal
      TRUE       ~ NA_real_
    ),
    
    # Edad (copiamos CH06 por claridad)
    edad = CH06
  ) %>%
  # Grupo educativo grande (baja / media / alta)
  # OJO: estos cortes son estándar; si los códigos de NIVEL_ED
  # son distintos en tu base, lo ajustamos luego.
  mutate(
    educ_grupo = case_when(
      NIVEL_ED %in% c(1, 2, 3)      ~ "Baja",   # sin instrucción / primaria
      NIVEL_ED %in% c(4, 5)         ~ "Media",  # secundaria
      NIVEL_ED %in% c(6, 7, 8, 9)   ~ "Alta",   # terciaria / universitaria
      TRUE                          ~ NA_character_
    )
  ) %>%
  # Pasamos a factores donde conviene
  mutate(
    sexo       = factor(sexo),
    educ_grupo = factor(educ_grupo,
                        levels = c("Baja", "Media", "Alta")),
    informal   = as.integer(informal)
  )

# (Opcional) Chequeos rápidos
# dim(base_limpia)
# table(base_limpia$informal, useNA = "ifany")
# table(base_limpia$educ_grupo, useNA = "ifany")
# table(base_limpia$sexo, useNA = "ifany")

# 6) Guardar base limpia -----------------------------------------------

saveRDS(base_limpia, "data/clean/eph_t3_2024_limpia.rds")
write.csv(base_limpia, "data/clean/eph_t3_2024_limpia.csv", row.names = FALSE)

############################################################
# Fin 01_limpieza.R
############################################################

