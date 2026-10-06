Grupo 02 mañana
# Informe 01 - Análisis Descriptivo Unidimensional

En este README encontrará una descripción de este proyecto en RStudio, y algunas instrucciones.

## Flujo de trabajo

Este proyecto se desarrolla utilizando RStudio, y se utiliza Git/GitHub para el control de versiones.

### Estructura principal

Existe una estructura convencional que debe respetar en mayor medida.

- `data/`: (local) En general, directorio reservado para datos.
  - `data/raw/`: Datos en bruto, **TAL Y COMO SE OBTUVIERON DE LA FUENTE**.
  - `data/processed/`: Datos procesados, listos para análisis. Normalmente, la modificación de estos datos **NUNCA SE REALIZA MANUALMENTE**.
- `scripts/`: Archivos `.R` con código que realiza el análisis.
- `outputs/`: (local) Archivos generados por los scripts, como gráficos, tablas, etc
- `renv`: Directorio que contiene el entorno de R utilizado en este proyecto.

### Convenciones

- `data/` es estrictamente local. El repositorio no debe contener datos.
  
  Los datos brutos `data/raw/` deben ser descargados de la fuente original.

  El directorio `data/processed/` debe ser generado a partir de los datos brutos, mediante scripts de procesamiento encontrados en `scripts/`.

  Esto significa que si usted desea realizar una modificación a un dato bruto, no debe hacerlo manualmente, sino mediante un script reproducible.

- `scripts/` debe contener scripts que se ejecutan en orden para generar los datos procesados o realizar análisis.
  
  Es recomendable que cada script esté numerado (`01-`, `02-`, etc.) para indicar el orden en que deben ejecutarse; si es que dicho orden existe.

  Si quiere usted crear una función que se utilizará en varios scripts, puede usted hacerlo en un script no numerado. Es recomendable que dicho tenga un nombre significativo, por ejemplo `utilidades.R` o `funciones.R`.

- `outputs/` es estrictamente local. El repositorio no debe contener archivos generados por los scripts.

  Esto significa que si usted desea generar un gráfico, tabla, etc., no debe hacerlo manualmente, sino mediante un script reproducible.

- `here::here()` es la forma recomendada de referirse a archivos dentro del proyecto. Esto significa que usted no debe utilizar rutas absolutas, ni rutas relativas que dependan de la ubicación del script.

## Como empezar a trabajar

Recuerde que este proyecto utiliza `git` como sistema de control de versiones, y RStudio utilizará la consola y la versión que tenga usted instalada para interactuar con `git`.

1. Clonar el repositorio.
   
   Puede usted clonar el repositorio mediante una terminal, si sabe cómo hacerlo, o mediante la interfaz de RStudio.

   En RStudio, puede usted ir a `File` > `New Project` > `Version Control` > `Git`, y luego pegar la URL del repositorio. Luego, solo ha de elegir un directorio local donde se clonará el repositorio.

   Si lo prefiere:
   ```
   git clone https://github.com/TeRacksito/G02_Informe_01
   ```
   Pero depende de qué tipo de autenticación tenga usted en GitHub.
   
2. Restaurar el entorno virtual (`renv`)
   
   Este proyecto utiliza `renv` para manejar las dependencias de R. Esto significa que evitamos utilizar paquetes instalados globalmente.

   Si no tiene usted `renv`, RStudio debería preguntarle automáticamente si desea instalarlo.

   Cada vez que usted clone el repositorio, o descargue cambios nuevos, deberá restaurar el entorno virtual. Esto se hace ejecutando el siguiente comando en la consola de RStudio:
   ```R
    renv::restore()
    ```
   
3. Posiblemente, ejecutar scripts numerados
   
   Posiblemente sea de su interés ejecutar los scripts numerados para generar los datos procesados y los resultados de análisis; si es que dichos scripts existen y son funcionales.

## Ayuda

### Comandos útiles de `renv`

- Actualizar el entorno virtual
  
  Si es la primera vez que clona usted el repositorio, o si ha hecho *pull* de cambios que modifican el entorno virtual, deberá ejecutar:
  ```R
  renv::restore()
  ```
  
- Comprobar el estado del entorno virtual
  
  Puede usted comprobar si el entorno virtual está actualizado ejecutando:
  ```R
  renv::status()
  ```
  
- Instalar un paquete nuevo
  
  Una vez sepa usted con certeza que el entorno virtual está funcionando, y además desea instalar un paquete nuevo, puede usted hacerlo mediante:
  ```R
  install.packages("nombre_del_paquete")
  ```
  
- Guardar los cambios del entorno virtual
  
  Si usted ha instalado un paquete nuevo, o ha actualizado un paquete existente, y desea guardar los cambios en el entorno virtual, puede usted hacerlo mediante:
  ```R
  renv::snapshot()
  ```
  > [!WARNING] Tenga cuidado
  > Si no hace usted `snapshot()`, los cambios que haga en el entorno virtual no se guardarán; aunque haga *commit*. Probablemente, si usted ha instalado un nuevo paquete es porque también lo ha utilizado en un script, y por lo tanto, si no hace `snapshot()`, el proyecto no será reproducible para otros usuarios.
  > 
  > El único escenario en el que no es necesario hacer `snapshot()` es cuando usted ha instalado un paquete nuevo, pero con el único propósito de probarlo, en algún script temporal que no ha sido agregado al repositorio. En ese caso, no es necesario hacer `snapshot()`, y de hecho, no es recomendable hacerlo.

### Como usar `here::here()`

- Cargar o leer datos
  
  ```R
  datos <- read.csv(here::here("data", "raw", "Cloud_Performance_01.csv"))
  ```

  donde `data/raw/Cloud_Performance_01.csv` es la ruta relativa al archivo de datos, desde la raíz del proyecto.
  
- Guardar resultados
  
  ```R
  write.csv(resultados, here::here("outputs", "tablas", "resultados.csv"))
  ```

  donde `outputs/tablas/resultados.csv` es la ruta relativa al archivo de resultados, desde la raíz del proyecto.
  
- Ejecutar un script dentro de otro
  
  ```R
  source(here::here("scripts", "01-procesamiento.R"))
  ```
  donde `scripts/01-procesamiento.R` es la ruta relativa al script, desde la raíz del proyecto.