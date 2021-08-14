fzf_kubectl_get_namespace_name() {
  # Function to fuzzy select a namespace

  kubectl get namespaces |
    awk '{print $1}' |
    grep -v NAME |
    fzf --no-multi --header "Select a namespace"
}

fzf_kubectl_get_pod_name() {
  # Function to fuzzy-search pods (name only)

  kubectl -n $1 get pods |
    awk '{print $1}' |
    grep -v NAME |
    fzf --no-multi --header "Select a pod"
}

fzf_kubectl_get_pods() {
  # Function to get pods for a namespace

  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Get pods for a selected namespace."
         echo
         echo "usage: fzf_kubectl_get_pods [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Fuzzy search and select namespace
  local namespace=$(fzf_kubectl_get_namespace_name)

  if [[ "$namespace" = "" ]]; then
    echo "No namespace selected."
    return
  fi

  # Get pods for selected namespace
  kubectl -n $namespace get pods
}

fzf_kubectl_describe_pod() {
  # Function to fzf and describe selected pod

  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Describe a selected pod."
         echo
         echo "usage: fzf_kubectl_describe_pod [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Fuzzy search and select namespace
  local namespace=$(fzf_kubectl_get_namespace_name)

  if [[ "$namespace" = "" ]]; then
    echo "No namespace selected."
    return
  fi

  # Fuzzy search pod from selected namespace
  local pod=$(fzf_kubectl_get_pod_name $namespace)

  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  # Describe selected pod
  kubectl -n $namespace describe pod $pod
}

fzf_kubectl_logs_pod() {
  # Function to display logs of pod selected from fzf

  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Get logs for a selected pod."
         echo
         echo "usage: fzf_kubectl_logs_pod [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Fuzzy search and select namespace
  local namespace=$(fzf_kubectl_get_namespace_name)

  if [[ "$namespace" = "" ]]; then
    echo "No namespace selected."
    return
  fi

  # Fuzzy search pod from selected namespace
  local pod=$(fzf_kubectl_get_pod_name $namespace)

  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  # Get logs for selected pod
  kubectl -n $namespace logs $pod
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

fzf_kubectl_port_forward_pod() {
  # Function to port-forward pod selected from fzf

  # Parse command line arguments
  while getopts p:h flag
  do
    case "${flag}" in
      h) echo "Port-forward local host port to a selected pod."
         echo
         echo "usage: fzf_kubectl_port_forward_pod [options]"
         echo "  options:"
         echo "    -h         Print this help."
         echo "    -p port    Port-forward 'port'."
         return;;
      p) port=${OPTARG};;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Fuzzy search and select namespace
  local namespace=$(fzf_kubectl_get_namespace_name)

  if [[ "$namespace" = "" ]]; then
    echo "No namespace selected."
    return
  fi

  # Fuzzy search pod from selected namespace
  local pod=$(fzf_kubectl_get_pod_name $namespace)

  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  if ! (( ${+port} )); then
    port=$(kubectl_get_pod_port $pod)

    if [[ "$port" = "" ]]; then
      # Prompt user for port to forward
      echo "No default port specified for the $pod pod."
      printf '%s ' 'Which port do you wish to use?'
      read port

      # Verify manually entered port is a number
      if ! [[ "$port" =~ "^[0-9]+$" ]]; then
        echo "Port specified is not a number."
        return
      fi
    fi
  fi

  # Port-forward local host port to default port for selected pod
  kubectl -n $namespace port-forward pod/$pod $port
}

fzf_kubectl_exec_pod() {
  # Function to exec into pod

  # Parse command line arguments
  while getopts p:h flag
  do
    case "${flag}" in
      h) echo "Exec into a selected pod."
         echo
         echo "usage: fzf_kubectl_port_forward_pod [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Fuzzy search and select namespace
  local namespace=$(fzf_kubectl_get_namespace_name)

  if [[ "$namespace" = "" ]]; then
    echo "No namespace selected."
    return
  fi

  # Fuzzy search pod from selected namespace
  local pod=$(fzf_kubectl_get_pod_name $namespace)

  if [[ "$pod" = "" ]]; then
    echo "No pod selected."
    return
  fi

  # Exec /bin/bash in selected pod
  kubectl -n $namespace exec $pod -it -- /bin/bash
}

# aliases
alias kgp="fzf_kubectl_get_pods"
alias kdp="fzf_kubectl_describe_pod"
alias klp="fzf_kubectl_logs_pod"
alias kpf="fzf_kubectl_port_forward_pod"
alias kep="fzf_kubectl_exec_pod"
