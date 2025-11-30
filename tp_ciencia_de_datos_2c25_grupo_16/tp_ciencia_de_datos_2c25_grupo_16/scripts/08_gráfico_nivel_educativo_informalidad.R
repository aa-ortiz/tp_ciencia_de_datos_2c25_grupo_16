############################################################
# 08_grafico_nivel_educativo_informalidad.R
# Gráfico final con storytelling
############################################################

library(dplyr)
library(ggplot2)
library(scales)

# 1) Cargar base y volver a estimar el modelo ------------------------

base_modelo <- readRDS("data/clean/eph_t3_2024_modelo.rds")

base_modelo <- base_modelo %>%
  mutate(
    educ_grupo = factor(educ_grupo, levels = c("Baja", "Media", "Alta")),
    sexo       = factor(sexo,       levels = c("Varón", "Mujer"))
    # Ojo: acá NO tocamos AGLOMERADO, lo dejamos como viene (numérico)
  )

modelo_logistico <- glm(
  informal ~ educ_grupo * sexo + edad + AGLOMERADO,
  data   = base_modelo,
  family = binomial(link = "logit")
)

# 2) Crear data frame para predicciones ------------------------------

# Combinaciones de educación y sexo
pred_df <- expand.grid(
  educ_grupo = levels(base_modelo$educ_grupo),
  sexo       = levels(base_modelo$sexo)
) %>%
  mutate(
    edad       = median(base_modelo$edad, na.rm = TRUE),
    # usamos un valor válido de AGLOMERADO con el mismo tipo que en el modelo (numérico)
    AGLOMERADO = base_modelo$AGLOMERADO[1]
  )

# Probabilidades predichas
pred_df$prob_informal <- predict(
  modelo_logistico,
  newdata = pred_df,
  type = "response"
)

pred_df$prob_inf_pct <- pred_df$prob_informal * 100

# (opcional) guardar tabla de probabilidades para el informe
dir.create("data/processed", showWarnings = FALSE)
write.csv(pred_df,
          "data/processed/prob_informal_predichas_logit.csv",
          row.names = FALSE)


# 3) Gráfico final con storytelling ----------------------------------

graf_prob <- ggplot(pred_df,
                    aes(x = educ_grupo,
                        y = prob_informal,
                        fill = sexo)) +
  geom_col(position = position_dodge(width = 0.7)) +
  
  # Etiquetas de porcentaje
  geom_text(
    aes(label = paste0(round(prob_inf_pct, 1), "%")),
    position = position_dodge(width = 0.7),
    vjust = 1.4,          # las mete dentro de la barra
    color = "white",
    size = 3.5
  )+
  
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, max(pred_df$prob_informal) * 1.25)  # un poco de aire arriba
  ) +
  
  labs(
    title = "La educación reduce la informalidad y achica la brecha de género",
    subtitle = "Probabilidad predicha de trabajo informal según nivel educativo y sexo.\nModelo logístico con controles por edad y aglomerado.",
    x = "Nivel educativo",
    y = "Probabilidad predicha de informalidad",
    fill = "Sexo",
    caption = "Fuente: elaboración propia en base a EPH-INDEC (T3 2024)."
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    plot.subtitle = element_text(size = 10),
    legend.position = "bottom"
  )

# 4) Mostrar en pantalla
print(graf_prob)

# 5) Guardar archivo
dir.create("output", showWarnings = FALSE)
ggsave("output/grafico_prob_informalidad_logit.png",
       graf_prob, width = 8, height = 5)

############################################################
# Fin 08_grafico_nivel_educativo_informalidad.R
############################################################

