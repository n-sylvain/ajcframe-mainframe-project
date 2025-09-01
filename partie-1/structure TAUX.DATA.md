# Structure du fichier TAUX.DATA

## Format du fichier
- **Type** : Séquentiel
- **Séparateur** : Point-virgule (;)
- **Taille max d'enregistrement** : 20 caractères
- **Format** : DEVISE;TAUX_VERS_USD

## Contenu proposé pour API6.PROJET.TAUX.DATA
```
EU;1.10
YU;0.15
WN;0.00075
RMB;0.14
YN;0.0067
```

## Correspondance des devises
| Code | Devise | Taux vers USD | Exemple |
|------|--------|---------------|---------|
| EU   | Euro   | 1.10          | 100 EUR = 110 USD |
| YU   | Yuan   | 0.15          | 100 CNY = 15 USD |
| WN   | Won    | 0.00075       | 100 KRW = 0.075 USD |
| RMB  | Renminbi | 0.14        | 100 CNY = 14 USD |
| YN   | Yen    | 0.0067        | 100 JPY = 0.67 USD |
| DO   | Dollar | 1.00          | (Pas besoin, devise de référence) |

## Notes
- Le dollar (DO) n'apparaît pas dans le fichier car c'est la devise de référence (taux = 1.00)
- Les taux sont donnés pour 1 unité de devise étrangère vers USD
- Pour convertir : `prix_usd = prix_origine * taux`