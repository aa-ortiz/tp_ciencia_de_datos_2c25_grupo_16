# Trabajo Final – Ciencia de Datos para Economía y Negocios
## Análisis de informalidad laboral en Argentina (EPH – T3 2024)

Este proyecto analiza la relación entre **nivel educativo**, **sexo** y la **probabilidad de trabajar en la informalidad**, utilizando los microdatos de la **EPH-INDEC (Tercer Trimestre 2024)**.

El trabajo sigue estrictamente la estructura, metodología y requisitos solicitados en la consigna.

---

## 🗂️ Estructura del proyecto

```txt
proyecto/
├── data/
│   ├── raw/          # Datos crudos originales (EPH)
│   ├── clean/        # Datos limpios
│   └── processed/    # Datos procesados finales
├── output/
│   ├── tables/       # Tablas generadas
│   └── figures/      # Gráficos para el informe
├── scripts/          # Scripts del proyecto
└── README.md         # Este archivo
```

# 📜 Scripts incluidos

Todos los scripts son reproducibles y están numerados de forma secuencial:

### **00_descarga_de_datos.R**
Descarga la base original del INDEC con el paquete `eph`.

### **01_limpieza.R**
Filtra población objetivo, crea variables clave (sexo, edad, informalidad, grupos educativos).

### **02_outliers_faltantes.R**
Analiza NA, outliers y construye la base final `base_modelo`.

### **03_eda.R**
Análisis exploratorio:
- Tablas de informalidad
- Porcentajes
- Primeros gráficos exploratorios

### **04_estadisticas_descriptivas.R**
Cálculo de:
- Media, mediana, moda
- Desvío, IQR, rango
- Histogramas y boxplots

### **05_impacto_limpieza.R**
Compara:
- Base cruda vs limpia vs modelo  
- Cambios en distribución de sexo, educación y edad

### **06_inferencia.R**
Incluye:
- Test Chi² (informalidad–educación y sexo)
- Regresión logística completa
- Odds ratios

### **07_grafico_informalidad_edad.R**
Gráfico editorializado:
**Informalidad por grupo de edad y sexo**

### **08_grafico_nivel_educativo_informalidad.R**
Gráfico editorializado:
**Probabilidad predicha de informalidad según nivel educativo y sexo**

---

# 🧪 Hipótesis del estudio

**Hipótesis principal (falsable):**  
> *“Un mayor nivel educativo reduce la probabilidad de trabajar en la informalidad, y esta reducción es diferente entre varones y mujeres.”*

Variables relevantes:
- Nivel educativo  
- Sexo  
- Informalidad laboral  
- Edad  
- Aglomerado urbano  

---

# 🔍 Diseño metodológico

1. Descargar y limpiar microdatos de EPH-INDEC  
2. Definir población: ocupados 18–64  
3. Construir variable informalidad  
4. Crear grupos educativos  
5. Controlar NA y outliers  
6. EDA: tablas, gráficos y distribución de variables  
7. Estadísticas descriptivas formales  
8. Test de hipótesis (Chi²)  
9. Regresión logística  
10. Dos gráficos editorializados  
11. Conclusiones  

---

# 📊 Visualizaciones incluidas

**Gráficos editorializados (obligatorios):**
1. Informalidad por grupo de edad y sexo  
2. Probabilidad predicha de informalidad según nivel educativo y sexo (modelo logit)

**Gráficos adicionales:**
- Histogramas  
- Boxplots  
- Barras por nivel educativo  
- Barras educación × sexo  

---

# 📈 Resultados principales

- La informalidad disminuye consistentemente con el nivel educativo.  
- Las mujeres presentan niveles de informalidad mayores en casi todos los grupos educativos.  
- El test Chi² confirma que la informalidad depende tanto del sexo como del nivel educativo.  
- La regresión logística muestra una reducción significativa en las probabilidades a medida que aumenta la educación.  
- La interacción educación×sexo es relevante: la educación reduce la brecha de género en informalidad.

---

# 📦 Cómo reproducir el proyecto

> **Pasos:**
1. Clonar el repositorio  
2. Abrir proyecto en RStudio  
3. Ejecutar los scripts en orden, del **00** al **08**  
4. Ver resultados en la carpeta **output/**  
5. La presentación se encuentra en formato PPTX dentro del repo

Requisitos:
- R ≥ 4.2  
- Paquetes: `tidyverse`, `eph`, `ggplot2`, `scales`, `dplyr`, `tidyr`

---

# 👥 Autores
- **Araceli Ortiz Escobar y Nicolás Pérez Cau**

---

# ✔ Estado del proyecto
**Completado y reproducible.**

---
