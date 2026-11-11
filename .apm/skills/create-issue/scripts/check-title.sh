#!/usr/bin/env bash
# Comprueba la forma del título de una issue o una pull request.
# En inglés, menos de 72 caracteres, empieza por un verbo en mayúscula, sin tipo delante ni número de issue.
# El idioma no se puede comprobar aquí: lo comprueba quien escribe el título.

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: check-title.sh TITULO" >&2
  exit 1
fi

title=$1

if [[ -z "$title" || "$title" =~ ^[[:space:]] || "$title" =~ [[:space:]]$ ]]; then
  echo "El título no puede estar vacío ni empezar o acabar con espacios." >&2
  exit 1
fi

if (( ${#title} >= 72 )); then
  echo "El título tiene ${#title} caracteres: tiene que tener menos de 72." >&2
  exit 1
fi

if [[ "$title" =~ ^[A-Za-z]+(\([^\)]*\))?!?: ]]; then
  echo "El título no lleva el tipo delante: «${title%%:*}:» sobra. El tipo va en la etiqueta." >&2
  exit 1
fi

if [[ "$title" =~ \#[0-9] ]]; then
  echo "El título no lleva el número de la issue." >&2
  exit 1
fi

if [[ ! "$title" =~ ^[A-Z] ]]; then
  echo "El título empieza por un verbo en inglés con mayúscula, como Add, Fix o Document." >&2
  exit 1
fi

if [[ "$title" == *. ]]; then
  echo "El título no acaba en punto." >&2
  exit 1
fi

echo "Título válido."
