############################################################
# 07_grafico_informalidad_edad.R
# Porcentaje de trabajadores informales según grupo de edad y sexo
############################################################

library(dplyr)
library(ggplot2)
library(scales)

# 1) Cargar base lista para análisis ------------------------

# Usamos la misma base que para el modelo logístico
base_modelo <- readRDS("data/clean/eph_t3_2024_modelo.rds")

# Aseguramos tipos y definimos grupos de edad
base_modelo <- base_modelo %>%
  mutate(
    sexo = factor(sexo, levels = c("Varón", "Mujer")),
    # Grupos de edad: 18–24, 25–34, 35–44, 45–54, 55–64
    edad_grupo = cut(
      edad,
      breaks = c(18, 25, 35, 45, 55, 65),
      right  = FALSE,
      labels = c("18-24", "25-34", "35-44", "45-54", "55-64")
    )
  )

# 2) Calcular porcentaje de informalidad por grupo de edad y sexo ----

porc_inf_edad <- base_modelo %>%
  filter(!is.na(informal),
         !is.na(edad_grupo),
         !is.na(sexo)) %>%
  group_by(edad_grupo, sexo) %>%
  summarise(
    n          = n(),
    n_informal = sum(informal == 1),
    prop_inf   = n_informal / n,
    .groups = "drop"
  ) %>%
  mutate(
    pct_inf = prop_inf * 100
  )

print(porc_inf_edad)

# 3) Gráfico editorializado ----------------------------------

graf_inf_edad <- ggplot(porc_inf_edad,
                        aes(x = edad_grupo,
                            y = prop_inf,
                            color = sexo,
                            group = sexo)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  # Etiquetas de porcentaje: distinto vjust para separar Varón/Mujer
  geom_text(
    aes(label = paste0(round(pct_inf, 1), "%"),
        vjust = ifelse(sexo == "Mujer", -0.8, 1.4)),
    show.legend = FALSE,   # evita que aparezcan las 'a' en la leyenda
    size = 3.2
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, max(porc_inf_edad$prop_inf) * 1.25),
    expand = expansion(mult = c(0, 0.05))
  ) +
  scale_color_manual(values = c("Varón" = "#FF9280",
                                "Mujer" = "#00C2C7")) +
  labs(
    title = "La informalidad disminuye con la edad, pero afecta más a las mujeres",
    subtitle = "Porcentaje de ocupados informales por grupo de edad y sexo.",
    x = "Grupo de edad",
    y = "Porcentaje de informalidad",
    color = "Sexo",
    caption = "Fuente: elaboración propia en base a EPH-INDEC (T3 2024)."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    plot.subtitle = element_text(size = 10),
    legend.position = "bottom"
  )

# 4) Mostrar en pantalla
print(graf_inf_edad)

# 5) Guardar archivo
dir.create("output", showWarnings = FALSE)
ggsave("output/grafico_informalidad_edad_sexo.png",
       graf_inf_edad, width = 8, height = 5)

############################################################
# Fin 07_grafico_informalidad_edad.R
############################################################
#