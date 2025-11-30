############################################################
# 06_inferencia.R
# Análisis de Estadística Inferencial:
# Test de Hipótesis (Chi²) y Regresión Logística
############################################################

library(dplyr)

# 1) Cargar base final para el modelo ------------------------
base_modelo <- readRDS("data/clean/eph_t3_2024_modelo.rds")

# Aseguramos tipos de variables para el modelo
base_modelo <- base_modelo %>%
  mutate(
    # informal YA es 0/1 desde los scripts anteriores, no la pasamos a factor
    educ_grupo = factor(educ_grupo, levels = c("Baja", "Media", "Alta")),
    sexo       = factor(sexo,       levels = c("Varón", "Mujer")),
    AGLOMERADO = as.factor(AGLOMERADO)
  )

############################################################
# 2) Test de Hipótesis (Requisito 1: Chi-Cuadrado)
############################################################

# A. Test: Informalidad vs Nivel Educativo
tabla_inf_edu <- table(base_modelo$informal, base_modelo$educ_grupo)
print(tabla_inf_edu)

test_chi2_edu <- chisq.test(tabla_inf_edu)
print(test_chi2_edu)

capture.output(test_chi2_edu,
               file = "data/clean/test_chi2_informalidad_educacion.txt")


# B. Test: Informalidad vs Sexo
tabla_inf_sexo <- table(base_modelo$informal, base_modelo$sexo)
print(tabla_inf_sexo)

test_chi2_sexo <- chisq.test(tabla_inf_sexo)
print(test_chi2_sexo)

capture.output(test_chi2_sexo,
               file = "data/clean/test_chi2_informalidad_sexo.txt")


############################################################
# 3) Regresión Logística (Requisito 2)
############################################################

# Modelo: probabilidad de ser INFORMAL (1)
# Hipótesis central: interacción educ_grupo * sexo

modelo_logistico <- glm(
  informal ~ educ_grupo * sexo + edad + AGLOMERADO,
  data   = base_modelo,
  family = binomial(link = "logit")
)

summary(modelo_logistico)

capture.output(summary(modelo_logistico),
               file = "data/clean/summary_regresion_logistica.txt")

# Odds Ratios para interpretación
odds_ratios <- exp(coef(modelo_logistico))
print("Odds Ratios:")
print(odds_ratios)

capture.output(odds_ratios,
               file = "data/clean/odds_ratios_regresion_logistica.txt")

############################################################
# Fin 06_inferencia.R
##########################################################

