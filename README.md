# Sistema de Monitoreo de Edificio Crisanto Luque

Este proyecto implementa un sistema de monitoreo de edificios utilizando sensores ETNA-2 para detectar sismos. Los datos recopilados se procesan y almacenan en un lago de datos en AWS.

## Tabla de Contenidos

- [Introducción](#introducción)
- [Características](#características)
- [Instalación](#instalación)
- [Uso](#uso)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Autores](#autores)

## Introducción

El proyecto de monitoreo de edificios tiene como objetivo proporcionar un sistema de alerta temprana y análisis en tiempo real de datos sísmicos para garantizar la seguridad de las estructuras y las personas dentro de los edificios. Utiliza sensores distribuidos en el edificio para recopilar datos que se procesan y analizan utilizando tecnologías de Python y se despliegan en AWS con Terraform.

## Características

- Monitoreo en tiempo real de datos sísmicos.
- Alerta temprana en caso de detección de sismos.
- Almacenamiento y procesamiento de datos en AWS.
- Análisis histórico y en tiempo real de datos sísmicos.

## Instalación

### Requisitos Previos

- Cuenta de AWS
- Terraform instalado
- Python instalado
- Acceso a Google Colab (opcional para análisis de datos)

### Pasos de Instalación

1. Clona el repositorio

    ```bash
    git clone https://github.com/tu_usuario/monitoreo-edificios.git
    cd monitoreo-edificios
    ```

2. Configura las credenciales de AWS

    ```bash
    export AWS_ACCESS_KEY_ID=tu_access_key_id
    export AWS_SECRET_ACCESS_KEY=tu_secret_access_key
    ```

3. Despliega la infraestructura en AWS con Terraform

    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

4. Instala las dependencias de Python

    ```bash
    pip install -r requirements.txt
    ```

## Uso

### Procesamiento de Datos con Python

1. Abre el notebook de Google Colab para procesar y analizar los datos sísmicos

    ```bash
    open colab/ProcesamientoDatos.ipynb
    ```

2. Ejecuta las celdas del notebook para analizar los datos en tiempo real y generar alertas.

### Monitoreo y Alerta

1. Ejecuta el script de monitoreo en Python

    ```bash
    python src/monitoreo.py
    ```

2. Los datos recopilados se enviarán y almacenarán en el lago de datos en AWS para análisis posterior.

## Contribuir

¡Las contribuciones son bienvenidas! Para contribuir, sigue estos pasos:

1. Haz un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-feature`)
3. Realiza tus cambios y haz commit (`git commit -am 'Añadir nueva feature'`)
4. Haz push a la rama (`git push origin feature/nueva-feature`)
5. Abre un pull request

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - mira el archivo [LICENSE](LICENSE) para más detalles.

## Autores

- **Andres Felipe Rivero** - *Trabajo Inicial* - [GitHub]([https://github.com/afriveros)
- **Andres Quiroga Ruiz** - *Contribuciones adicionales* - [GitHub](https://github.com/AndresR10Q)
- **Camilo Cardenas** - *Contribuciones adicionales* - [GitHub](https://github.com/kmilo95)
