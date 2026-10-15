# Inception-of-things
*Projet 42 - Découverte et maîtrise de Kubernetes via K3s.*  
*Réalisé par lperis, amblanch, qumiraud.*

---

## Partie 1 : Cluster K3s multi-nœuds avec Vagrant

**Outils utilisés :** Vagrant, K3s

### Objectif
L'objectif de cette première partie est de déployer un cluster K3s minimaliste composé de deux nœuds :
*   **1 Control-plane :** L'orchestrateur du cluster qui pilote les nœuds de travail via les commandes passées avec `kubectl`.
*   **1 Worker :** Le nœud de travail qui exécute les charges utiles (workloads).

### Architecture et Automatisation
L'automatisation du provisionnement des machines virtuelles (VMs) est gérée par **Vagrant**. Grâce au `Vagrantfile`, nous définissons la configuration de l'infrastructure en code (Infrastructure as Code) :
*   **Système d'exploitation** et ressources allouées.
*   **Réseau statique imposé :** 
    *   Control-plane : `192.168.56.110`
    *   Worker : `192.168.56.111`
*   **Provisioning :** Exécution de scripts au lancement pour installer K3s.

Afin que le nœud worker puisse rejoindre le cluster, le control-plane génère un token d'identification. Ce partage est rendu possible grâce à un répertoire synchronisé monté par Vagrant dans `/vagrant/k3s-token`.

```ruby
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|

  config.vm.box = "debian/bookworm64"
  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.define "server" do |server|
    server.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    server.vm.hostname = "Server"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provision "file", source: "~/Inception-of-things/p1/confs/config.yaml", destination: "/tmp/config.yaml"
    server.vm.provision "shell", name: "init-server", path: "./scripts/init-server.sh"
  end

  config.vm.define "worker" do |worker|
    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    worker.vm.hostname = "Worker"
    worker.vm.network "private_network", ip: "192.168.56.111"

    worker.vm.provision "shell", name: "init-worker", path: "./scripts/init-worker.sh"
  end
end
```
### 🛠️ Commandes de vérification
Pour s'assurer que le cluster est fonctionnel et que les nœuds communiquent correctement :

```bash
# Se connecter à une VM pour vérifier son état
vagrant ssh <nom_de_la_VM>

# Vérifier l'état des nœuds (à exécuter depuis le control-plane)
kubectl get nodes -o wide
```

---

## Partie 2 : Déploiement d'applications et Ingress Controller

**Outils utilisés :** Vagrant, K3s

### Objectif
Réaliser l'hébergement de 3 applications web (app1, app2, app3) sur un cluster K3s *single-node*. Ces applications doivent être accessibles via leurs propres URLs grâce à un **Ingress**, qui agit comme un point d'entrée unique et route le trafic (similaire à une API Gateway). 

**Règles de routage et spécificités :**
*   **app1** : Routage standard.
*   **app2** : Haute disponibilité avec **3 replicas**.
*   **app3** : Configurée comme la **route par défaut** (catch-all).

p2/ 

├── confs/  
│   ├── app1/  
│   │   ├── deployment.yaml  
│   │   └── service.yaml  
│   ├── app2/  
│   │   ├── deployment.yaml  
│   │   └── service.yaml  
│   ├── app3/  
│   │   ├── deployment.yaml  
│   │   └── service.yaml  
│   └── ingress.yaml  
├── scripts/  
│   └── setup.sh   
└── Vagrantfile  

### Déploiement
Pour cette étape, le `Vagrantfile` provisionne une seule VM. Les 3 applications web sont instanciées via des manifestes Kubernetes (`deployment.yaml` et `service.yaml`) appliqués automatiquement par un script de provisionnement. Au total, le cluster fera tourner 5 pods applicatifs (dont 3 dédiés à app2).

### 🛠️ Commandes de vérification
Pour valider le déploiement et le routage de l'Ingress :

```bash
# Lister l'ensemble des ressources (pods, services, deployments, replicasets)
kubectl get all

# Tester le routage de l'Ingress en simulant un appel HTTP vers app2
curl -H "Host: app2.com" http://192.168.56.110
```

## Partie 3 : GitOps et Déploiement Continu avec K3d et ArgoCD

**Outils utilisés :** K3d, K3s, Docker, ArgoCD, ArgoCD CLI, kubectl

### Objectifs
Mettre en œuvre un pipeline de Déploiement Continu (CD - Continuous Deployment) en s'appuyant sur le paradigme GitOps. Le but est d'utiliser ArgoCD pour synchroniser automatiquement l'état de notre cluster Kubernetes avec les manifestes déclaratifs versionnés sur un dépôt GitHub.

### Architecture et Déploiement
Dans cette étape, nous instancions un cluster local à l'aide de K3d (K3s encapsulé dans Docker). Ce cluster est structuré autour de deux namespaces distincts :
1.  **`argocd`** : Destiné à héberger l'infrastructure et les contrôleurs du serveur ArgoCD. Le mot de passe administrateur initial y sera extrait pour permettre l'accès à l'interface web.
2.  **`dev`** : L'environnement cible destiné à accueillir notre charge de travail, l'application `wil42`.

Une fois ArgoCD opérationnel, nous déclarons notre application via la CLI. ArgoCD agit alors comme un contrôleur qui scrute en permanence le répertoire Git spécifié. Dès qu'une modification est validée sur le dépôt (par exemple, la mise à jour du tag de l'image Docker dans le manifeste), ArgoCD orchestre automatiquement le redéploiement de l'application dans le namespace `dev` afin que l'état du cluster reflète exactement celui du code source.

### Configuration de l'application via CLI

La création de l'application et la définition de ses règles de synchronisation s'effectuent via la commande suivante :

```bash
argocd app create wil42 \
  --repo [https://github.com/blanchetamaury/IOT_image](https://github.com/blanchetamaury/IOT_image) \
  #L'URL du dépôt Git agissant comme unique source de vérité.
  --path wil42_demo \
  #Le chemin vers le répertoire contenant les manifestes Kubernetes à observer.
  --dest-server [https://kubernetes.default.svc](https://kubernetes.default.svc) \
  #L'adresse de l'API interne du cluster cible.
  --dest-namespace dev \
  #Le namespace dans lequel les ressources applicatives seront déployées (dev).
  --sync-policy automated
  #Active la réconciliation automatique, permettant à ArgoCD d'appliquer les changements sans intervention manuelle.
``` 

### Architecture GitOps

```mermaid
graph TD
    classDef clusterStyle fill:#f9f9f9,stroke:#333,stroke-width:1px,stroke-dasharray: 0;
    classDef argoStyle fill:#fff,stroke:#000,stroke-width:2px;
    classDef dockerStyle fill:#09f,stroke:#05a,stroke-width:1px,color:#fff;
    
    Host["💻 Host (Machine Locale)"]
    Git["🐙 Git (Repository)"]
    Hub["🐳 Docker Hub"]

    subgraph K3D ["📦 Cluster K3D"]
        Argo["🔄 ARGO CD"]:::argoStyle
        App["🌐 App in Docker (www)"]:::dockerStyle
        
        Argo -->|"déploie / gère"| App
    end

    Host -->|"1. push code & manifests"| Git
    Git -->|"2. sync (GitOps)"| Argo
    
    Argo -.->|"3. check / pull image"| Hub
    Hub -.-> Argo
    
    Host <-->|"4. accède / teste l'application"| App

    linkStyle 0 stroke:#333,stroke-width:2px;
    linkStyle 1 stroke:#333,stroke-width:2px;
    linkStyle 2 stroke:#09f,stroke-width:1px,stroke-dasharray: 5 5;
    linkStyle 3 stroke:#09f,stroke-width:1px,stroke-dasharray: 5 5;
    linkStyle 4 stroke:#28a745,stroke-width:2px;

 

