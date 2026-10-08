# Inception-of-things
*Projet 42 - Découverte et maîtrise de Kubernetes via K3s.*

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

![Contenu du Vagrantfile](<Screenshot From 2026-10-08 10-01-21.png>)

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

![Arborescence de fichiers](<Screenshot From 2026-10-08 10-42-12.png>)

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