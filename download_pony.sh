#!/bin/bash

# Verificar si se proporcionó una API key como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <civitai_api_key>"
    exit 1
fi

# Asignar la API key de Civitai a una variable
CIVITAI_API_KEY=$1

# Definir el arreglo con los modelos
# Cada modelo es un arreglo con los siguientes campos: nombre, url, tipo de sitio, tipo de modelo
modelos=(
    ##Uber Realistic Porn Merge 🦄PonyXL-Hybrid (URPM)|✅XL & Pony LoRAs |✅ControlNet
    "realistic_pony.safetensors|https://civitai.com/api/download/models/923681?type=Model&format=SafeTensor&size=full&fp=fp16|civitai|checkpoint" 
    ##Speciosa 2.5D
    "speciosa_25D_pony.safetensors|https://civitai.com/api/download/models/634767?type=Model&format=SafeTensor&size=pruned&fp=fp16|civitai|checkpoint"
    ##Prefect Pony XL
    "prefectPony_XL.safetensors|https://civitai.com/api/download/models/828380?type=Model&format=SafeTensor&size=pruned&fp=fp16|civitai|checkpoint"
    ##NoctAbstract Trigger: abstract, abstract background, particles,colorful
    "noctabstract_pony_lora.safetensors|https://civitai.com/api/download/models/519148?type=Model&format=SafeTensor|civitai|lora"
    ##Midjourney V6 Style
    "midjourney_sdxl_lora.safetensors|https://civitai.com/api/download/models/280621?type=Model&format=SafeTensor|civitai|lora"
    ##Style filter] Xu Er thick paint composition light texture enhancement Trigger:
    "xuer_pony_lora.safetensors|https://civitai.com/api/download/models/860001?type=Model&format=SafeTensor"|civitai|lora
)

# Iterar sobre el arreglo de modelos
for modelo_info in "${modelos[@]}"; do
    IFS="|" read -r nombre url tipo_sitio tipo_modelo <<< "$modelo_info"

    # Determinar el directorio de destino según el tipo de modelo
    if [ "$tipo_modelo" == "checkpoint" ]; then
        directorio="/workspace/models/checkpoints"
    elif [ "$tipo_modelo" == "lora" ]; then
        directorio="/workspace/models/loras"
    else
        echo "Tipo de modelo desconocido: $tipo_modelo"
        continue
    fi

    # Construir el comando de descarga según el tipo de sitio
    if [ "$tipo_sitio" == "huggingface" ]; then
        # Descargar desde HuggingFace
        comando="wget -c \"$url\" -P $directorio/$nombre"
    elif [ "$tipo_sitio" == "civitai" ]; then
        # Descargar desde Civitai con el token
        comando="wget -c \"$url&token=$CIVITAI_API_KEY\" -P $directorio/$nombre"
    else
        echo "Tipo de sitio desconocido: $tipo_sitio"
        continue
    fi

    # Ejecutar el comando de descarga
    echo "Ejecutando: $comando"
    eval $comando
done
