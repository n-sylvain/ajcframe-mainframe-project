def renumber_cobol_lines(input_file, output_file):
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            lines = infile.readlines()

        with open(output_file, 'w', encoding='utf-8') as outfile:
            line_count = 10000
            for line in lines:
                stripped = line.rstrip()

                # Ignore les lignes vides
                if not stripped.strip():
                    continue

                # Ignore les commentaires COBOL (zone A = colonne 7)
                if len(stripped) > 6 and stripped[6] == '*':
                    continue

                # Garde les 72 premiers caractères (zone de code COBOL)
                code_part = stripped[:72].rstrip()

                # Numérotation sur 8 chiffres
                line_number = f"{line_count:08d}"
                formatted_line = f"{code_part:<72}{line_number}\n"
                outfile.write(formatted_line)
                line_count += 100

        print(f"✅ Fichier traité avec succès : {output_file}")
    except Exception as e:
        print(f"❌ Erreur : {e}")


renumber_cobol_lines(
    r'C:\Mainframe\MS5CONX.bms',
    r'C:\Mainframe\MS5CONX.bmsddd'
)

