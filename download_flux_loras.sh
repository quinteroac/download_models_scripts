

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
    ##Flux Dev Complete
    "flux_dev.safetensors|https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors|huggingface|checkpoint" 
    ## Midjourney V6.1 meets FLUX 🖼️ [+SDXL] Trigger: aidmaMJ6.1, Strength: 0.5  DEV
    "flux_midjourney_lora.safetensors|https://civitai.com/api/download/models/925023?type=Model&format=SafeTensor|civitai|lora"
    ##Pony NSFW Style [FLUX] Trigger: aidmansfwunlockfluxponystyle 
    "flux_pony_lora.safetensors|https://civitai.com/api/download/models/756686?type=Model&format=SafeTensor|civitai|lora"
     ##Velvet's Mythic Fantasy Styles | Flux + Pony  Trigger: mythp0rt Strength: 1
    "flux_fantasy_lora.safetensors|https://civitai.com/api/download/models/753053?type=Model&format=SafeTensor|civitai|lora"
    ##DarkCore Clip Skip: 1 No trigger
    "flux_darkcore_lora.safetensors|https://civitai.com/api/download/models/747357?type=Model&format=SafeTensor|civitai|lora"
    ##Storybook  Trigger: sbfte
    "flux_storybook_lora.safetensors|https://civitai.com/api/download/models/723968?type=Model&format=SafeTensor|civitai|lora"
    ##FLUX 🌟FaeTastic Details FLUX DEV 
    "flux_faetastic_lora.safetensors|https://civitai.com/api/download/models/720252?type=Model&format=SafeTensor|civitai|lora"
    ##Ink-style FLUX DEV Strength: 1.2
    "flux_inkstyle_lora.safetensors|https://civitai.com/api/download/models/914935?type=Model&format=SafeTensor|civitai|lora"
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
        comando="wget -c \"$url\" -P .$directorio/$nombre"
    elif [ "$tipo_sitio" == "civitai" ]; then
        # Descargar desde Civitai con el token
        comando="wget -c \"$url&token=$CIVITAI_API_KEY\" -O .$directorio/$nombre"
    else
        echo "Tipo de sitio desconocido: $tipo_sitio"
        continue
    fi

    # Ejecutar el comando de descarga
    echo "Ejecutando: $comando"
    eval $comando
done
