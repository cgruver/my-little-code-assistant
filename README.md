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
```

## Machine Config to leak GPU into a Pod

__Note:__ `/dev/net/tun` and `/dev/fuse` are enabled OOTB.  They are included here for compatibility.  

```bash
cat << EOF | butane | oc apply -f -
variant: openshift
version: 4.18.0
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: enable-gpu
storage:
  files:
  - path: /etc/crio/crio.conf.d/99-intel-gpu
    mode: 0644
    overwrite: true
    contents:
      inline: |
        [crio.runtime]
        allowed_devices = [
          "/dev/fuse",
          "/dev/net/tun",
          "/dev/dri/by-path/pci-0000:00:02.0-render",
          "/dev/dri/renderD128"
        ]
EOF
```


Run LLama.CPP in workspace -

```bash
podman run -it --name llama --rm --device /dev/dri/renderD128 -p 8080:8080 --entrypoint /bin/bash -v /projects/model-dir:/model-dir:Z quay.io/cgruver0/che/my-code-assistant:latest

source /opt/intel/oneapi/setvars.sh
export RAMALAMA_STORE=/model-dir
ramalama pull ollama://granite3.1-moe:3b
llama-run --ngl 999 --jinja ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b hello
llama-server --model ${RAMALAMA_STORE}/models/ollama/granite3.1-moe:3b --host 0.0.0.0 --n-gpu-layers 999 --flash-attn --ctx-size 32768 --jinja
```
