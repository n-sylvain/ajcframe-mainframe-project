Groupe 5: (Machine 2)
- TEN KET KIAN Denis   API4 | API04
- ADYEL        Anouar  API5 | API05
- NI           Sylvain API6 | API06

IP : 54.38.29.76:3276

Kanban : denis 
https://miro.com/app/board/uXjVJWEBseo=/?passwordless_invite=

https://marketplace.visualstudio.com/items?itemName=spryinno.kanpilot


git clone https://github.com/n-sylvain/ajcframe-mainframe-project.git

puis

cd ajcframe-mainframe-project
code . # Opens the folder in VS Code

git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

git pull origin main




ajcframe-mainframe-project/
├── README.md
├── docs/
│   ├── description_projet.md
│   ├── planning.md
│   ├── agile_methodology.md
│   └── architecture_diagram.png
├── sql/
│   ├── BDDORDER.sql
│   ├── BDDPARTS.sql
│   └── inserts_sample.sql
├── data/
│   ├── NEWPRODS.txt
│   ├── VENTEAS.txt
│   ├── VENTEEU.txt
│   └── SOURCES/
│       ├── BDDORDER.TXT
│       ├── BDDPARTS.TXT
│       ├── NEWPRODS.TXT
│       ├── VENTEAS.txt
│       └── VENTESEU.txt
├── jcl/
│   ├── JCLNEWPRODS.jcl
│   ├── JCLVENTES.jcl
│   ├── JCLEXTRACT.jcl
│   └── JCLNEWPARTS.jcl
├── cobol/
│   ├── newprods.cbl
│   ├── ventes.cbl
│   ├── extract_factures.cbl
│   ├── sous_prog_date.cbl
│   └── ihm_cics.cbl
├── cics/
│   ├── PARTSX.cpy
│   ├── USERSX.cpy
│   ├── MAPX1.bms
│   ├── TXNEWPARTS.cbl
│   └── auth.cbl
├── sysin/
│   ├── taux_conversion.txt
│   └── tva.txt
├── tests/
│   ├── test_newprods.cbl
│   ├── test_ventes.cbl
│   └── test_facture.cbl
└── presentation/
    ├── slides.pptx
    └── demo_script.md
