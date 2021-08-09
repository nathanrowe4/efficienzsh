fzf_kubectl_get_pod() {
  # Function to fuzzy-search pods

  kubectl -n machine-learning get pods |
    grep -v NAME |
    fzf --no-multi --header "Select a pod"
}

fzf_kubectl_get_pod_name() {
  # Function to fuzzy-search pods (name only)

  kubectl -n machine-learning get pods |
    awk '{print $1}' |
    grep -v NAME |
    fzf --no-multi --header "Select a pod"
}

kubectl_get_pod_port() {
  # Function to return port of pod name

  # TODO: Generalize this and make it configurable
  declare -A pod_ports=(
    transformer 5000
    recommender 5000
    classifier 5005
    embedder 5000
  )

  for pod port in "${(@kv)pod_ports}"; do
    if [[ $1 = ${pod}* ]]; then
      echo $port
      return
    fi
  done
}

fzf_kubectl_pod_logs() {
  # Function to display logs of pod selected from fzf

  local pod

  pod=$(fzf_kubectl_get_pod_name)
  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  kubectl -n machine-learning logs $pod
}

fzf_kubectl_pod_port_forward() {
  # Function to port-forward pod selected from fzf

  local pod port

  pod=$(fzf_kubectl_get_pod_name)
  port=$(kubectl_get_pod_port $pod)
  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  kubectl -n machine-learning port-forward pod/$pod $port
}

# aliases
alias kgp="fzf_kubectl_get_pod"
alias kl="fzf_kubectl_pod_logs"
alias kpf="fzf_kubectl_pod_port_forward"
