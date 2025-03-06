# my-little-code-assistant
OpenShift Dev Spaces Code Assistant with Intel GPU - llama.cpp - continue.dev

```bash
podman build -t quay.io/cgruver0/che/my-code-assistant:latest ./llama-cpp-image
```

```
let gpu_index=0
for i in $(oc get nodes -o name)
do
  oc label ${i} gpu-index=${gpu_index}
  gpu_index=$(( ${gpu_index} + 1 ))
done


Run LLama.CPP in workspace -

```bash
podman run -it --name llama --rm --device /dev/dri/renderD128 -p 8080:8080 --entrypoint /bin/bash -v /projects/model-dir:/model-dir:Z quay.io/cgruver0/che/my-code-assistant:latest

source /opt/intel/oneapi/setvars.sh
export RAMALAMA_STORE=/model-dir
ramalama pull ollama://granite3.1-moe:3b
llama-run --ngl 999 --jinja ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b hello
llama-server --model ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b --host 0.0.0.0 --n-gpu-layers 999 --flash-attn --ctx-size 32768 --jinja
```
