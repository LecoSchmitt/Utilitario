# ==== Usuários ====
echo "=== Usuários ===" >> ./mapeamento_linux.txt
getent passwd >> ./mapeamento_linux.txt

# ==== Grupos ====
echo -e "\n=== Grupos ===" >> ./mapeamento_linux.txt
getent group >> ./mapeamento_linux.txt

# ==== Usuários por grupo ====
echo -e "\n=== Usuários por grupo ===" >> ./mapeamento_linux.txt

# Para cada grupo local:
while IFS=: read -r grupo _ gid membros_extras; do

    echo -e "\n--- Grupo: $grupo ---" >> ./mapeamento_linux.txt

    # Membros adicionais do grupo (campo 4 do /etc/group)
    membros_extras_formatados=$(echo "$membros_extras" | tr ',' '\n')

    # Usuários cujo GID primário é o GID do grupo
    membros_primarios=$(awk -F: -v g="$gid" '$4 == g {print $1}' /etc/passwd)

    # Unir tudo, remover vazios, ordenar, deduplicar
    (
        echo "$membros_extras_formatados"
        echo "$membros_primarios"
    ) | sed '/^$/d' | sort -u >> ./mapeamento_linux.txt

done < /etc/group
