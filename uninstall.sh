bash 
#!/bin/bash
# uninstall.sh - Désinstallation totale : app, ArgoCD, cluster k3d, outils

echo "=== Désinstallation totale ==="
read -p "Tout supprimer (cluster, ArgoCD, kubectl, argocd, k3d, helm) ? [y/N] " confirm
[[ "$confirm" =~ ^[yY]$ ]] || { echo "Annulé."; exit 0; }

# 1. Arrêter les port-forwards
echo "[1/7] Arrêt des port-forwards..."
pkill -f "kubectl port-forward" 2>/dev/null || true

# 2. Supprimer l'application ArgoCD (+ ses ressources déployées)
echo "[2/7] Suppression de l'application wil42..."
argocd app delete wil42 --cascade -y 2>/dev/null || true
kubectl delete application wil42 -n argocd --ignore-not-found 2>/dev/null || true

# 3. Supprimer ArgoCD
echo "[3/7] Suppression d'ArgoCD..."
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --ignore-not-found 2>/dev/null || true
kubectl delete namespace argocd --ignore-not-found 2>/dev/null || true
kubectl delete namespace dev --ignore-not-found 2>/dev/null || true

# 4. Supprimer le cluster k3d
echo "[4/7] Suppression du cluster k3d..."
k3d cluster delete 42cluster 2>/dev/null || true

# 5. Désinstaller les binaires
echo "[5/7] Suppression des binaires..."
sudo rm -f /usr/local/bin/argocd
sudo rm -f /usr/local/bin/kubectl
sudo rm -f /usr/local/bin/k3d
sudo rm -f /usr/local/bin/helm

# 6. Nettoyer les fichiers de config
echo "[6/7] Nettoyage des configs..."
rm -rf ~/.kube
rm -rf ~/.config/argocd
rm -rf ~/.k3d
rm -rf ~/.cache/helm
rm -rf ~/.config/helm
rm -rf ~/.local/share/helm
rm -f /tmp/argocd-pf.log

# 7. Nettoyer Docker (optionnel)
echo "[7/7] Nettoyage Docker..."
docker system prune -f 2>/dev/null || true

echo "=== Terminé ==="