# Arduidrone Controller

> **Travail de Maturité** — CEC André-Chavanne, Genève | Octobre 2024 – Novembre 2025

Interface de contrôle PC pour un drone quadricoptère entièrement conçu et imprimé en 3D, développée avec [Godot 4.5](https://godotengine.org/). Cette application communique en temps réel avec l'ordinateur de bord **ESP32** du drone via Wi-Fi (UDP + MessagePack) et permet de piloter l'appareil ainsi que de superviser ses données de vol.

---

## Table des matières

- [Contexte](#contexte)
- [Architecture du système](#architecture-du-système)
- [Matériel du drone](#matériel-du-drone)
- [Fonctionnalités de l'application](#fonctionnalités-de-lapplication)
- [Prérequis](#prérequis)
- [Installation et lancement](#installation-et-lancement)
- [Configuration réseau](#configuration-réseau)
- [Manettes supportées](#manettes-supportées)
- [Structure du projet](#structure-du-projet)
- [Auteurs](#auteurs)

---

## Contexte

Ce projet de maturité a été réalisé par **Romain Laou** et **Vivien Jeannet** au CEC André-Chavanne à Genève, sous la supervision de **Thierry Semaan** (professeur de TM). L'objectif était de construire intégralement un drone quadricoptère — de la modélisation 3D à l'algorithmie de vol — afin de passer de la théorie à la pratique en couvrant la mécanique, l'électronique et la programmation.

La structure du drone a été modélisée sous **OnShape**, imprimée en plastique ABS sur une **Bambu Lab P1S**, et programmée en C++ sur ESP32. Le premier vol libre stable a eu lieu en **octobre 2025**.

---

## Architecture du système

```
┌─────────────────────┐        Wi-Fi (UDP)        ┌─────────────────────┐
│   PC (Windows/Linux) │ ◄────────────────────────► │  Raspberry Pi       │
│  Arduidrone Controller│       port 12345          │  (point d'accès)    │
└─────────────────────┘                            └──────────┬──────────┘
                                                              │ Wi-Fi
                                                   ┌──────────▼──────────┐
                                                   │  ESP32 (drone)      │
                                                   │  Ordinateur de bord │
                                                   └─────────────────────┘
```

- **Protocole** : UDP sur le port `12345` (configurable)
- **Sérialisation** : [MessagePack](https://msgpack.org/)
- **Point d'accès** : Raspberry Pi configuré en hotspot Wi-Fi (`192.168.50.69` par défaut)
- **Fréquence d'envoi** : 60 Hz (configurable)

À chaque cycle, le contrôleur PC envoie au drone : les valeurs des axes (throttle, yaw, pitch, roll) et des flags (armement, etc.), ainsi que la liste des données télémétriques souhaitées en retour. Le drone répond avec les valeurs demandées (PID, IMU, vitesses moteurs, etc.).

---

## Matériel du drone

| Composant | Détails |
|---|---|
| Microcontrôleur | ESP32 |
| Moteurs | DJI 2312A (sans balais × 4) |
| IMU | MPU-9250 9 axes (gyroscope + accéléromètre + magnétomètre) |
| Structure | Plastique ABS, impression 3D (Bambu Lab P1S) |
| Logiciel de modélisation | OnShape + Bambu Studio |
| Modules additionnels | GPS, lidar, capteurs ultrasons |
| Algorithme de stabilisation | PID en cascade (angle + taux) sur pitch, roll et yaw |

---

## Fonctionnalités de l'application

- **Pilotage en temps réel** via manette de jeu (DJI ou standard) ou clavier
- **Télémétrie en direct** : angles pitch/roll/yaw, taux de rotation, throttle par moteur, fréquence de boucle, données de flux optique
- **Réglage des PID à la volée** : gains P, I, D pour l'angle de tilt, le taux de tilt et le taux de yaw
- **Affichage graphique** des données de vol (entrées/sorties/setpoints PID)
- **Terminal intégré** : log système, affichage du trafic UDP
- **Test de latence** : ping UDP (10 pings, latence moyenne)
- **Interface personnalisable** : widgets redimensionnables et déplaçables, zoom (Ctrl + molette)
- **Exports disponibles** : Windows (`.exe`) et Linux x86_64

---

## Prérequis

### Pour utiliser les exécutables pré-compilés

- Windows 10/11 (64 bits) **ou** Linux x86_64
- Une manette compatible (DJI RC, Xbox, PS4/PS5…) ou le clavier

### Pour compiler depuis les sources

- [Godot 4.5](https://godotengine.org/download/) (version `Forward Plus`)
- Aucune dépendance externe — le projet utilise uniquement GDScript et les API natives de Godot

---

## Installation et lancement

### Exécutables pré-compilés

| Plateforme | Fichier |
|---|---|
| Windows | `Arduidrone Controller.exe` |
| Linux | `Arduidrone Controller.x86_64` |

Téléchargez le fichier correspondant à votre système, puis lancez-le directement — aucune installation requise.

> **Linux** : il peut être nécessaire de rendre le fichier exécutable au préalable :
> ```bash
> chmod +x "Arduidrone Controller.x86_64"
> ./"Arduidrone Controller.x86_64"
> ```

### Depuis les sources (Godot Editor)

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/Romcodewasunavailable/arduidrone-controller.git
   ```
2. Ouvrez **Godot 4.5**, puis importez le projet `arduidrone-controller/project.godot`.
3. Lancez la scène principale depuis l'éditeur (`F5`).

---

## Configuration réseau

Par défaut, l'application tente de joindre le drone à l'adresse :

| Paramètre | Valeur par défaut |
|---|---|
| IP destination | `192.168.50.69` |
| Port destination | `12345` |
| Port local (écoute) | `12345` |

Ces valeurs peuvent être modifiées depuis le panneau **UDP Control Panel** de l'interface. Le Raspberry Pi doit être configuré comme point d'accès Wi-Fi et faire le pont entre le PC et l'ESP32 du drone.

---

## Manettes supportées

| Mode | Axes | Armement |
|---|---|---|
| **DJI** (défaut) | Stick droit X → Throttle, Stick droit Y → Yaw, Stick gauche Y → Pitch, Stick gauche X → Roll | Bouton B |
| **Standard** | Stick gauche Y → Throttle, Stick gauche X → Yaw, Stick droit Y → Pitch, Stick droit X → Roll | Bouton Start / Épaule droite |

Le mode peut être basculé depuis l'interface. En l'absence de manette, la touche **Home** du clavier permet d'armer/désarmer le drone.

---

## Structure du projet

```
arduidrone-controller/
├── arduidrone-controller/          # Sources Godot
│   ├── project.godot               # Configuration du projet
│   ├── scenes/                     # Scènes UI (.tscn)
│   │   ├── arduidrone_controller.tscn   # Scène principale
│   │   ├── controller_control_panel.tscn
│   │   ├── udp_control_panel.tscn
│   │   ├── data_graph_display.tscn
│   │   ├── throttle_display.tscn
│   │   ├── drone_model_display.tscn
│   │   └── terminal.tscn
│   ├── scripts/                    # Logique GDScript
│   │   ├── udp.gd                  # Autoload — gestion UDP globale
│   │   ├── udp_client.gd           # Client UDP bas niveau (thread dédié)
│   │   ├── controller.gd           # Autoload — état manette & envoi commandes
│   │   ├── drone.gd                # Autoload — état télémétrique du drone
│   │   ├── messagepack.gd          # Encodeur/décodeur MessagePack
│   │   └── ...
│   └── visuals/                    # Ressources graphiques
│       ├── arduidrone_model.obj    # Modèle 3D du drone
│       └── drone_top_shot.png
├── Arduidrone Controller.exe       # Export Windows
└── Arduidrone Controller.x86_64   # Export Linux
```

---

## Auteurs

| Rôle | Nom | Contact |
|---|---|---|
| Auteur principal | Vivien Jeannet | vivienjeannet23@gmail.com |
| Auteur principal | Romain Laou | rlaou08@gmail.com |
| Superviseur (TM) | Thierry Semaan | — |

**Établissement** : CEC André-Chavanne, Genève  
**Année académique** : 2024 – 2025
