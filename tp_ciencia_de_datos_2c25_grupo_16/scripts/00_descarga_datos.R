#00_descarga_de_datos

install.packages("eph")
library(eph)

eph_t3_2024 <- get_microdata(year = 2024, trimester = 3, type = "individual")
