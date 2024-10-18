#!/bin/bash

# Загружаем переменные из .env
export $(grep -v '^#' .env | xargs)

# Преобразуем список запрещенных слов в массив
IFS=',' read -r -a prohibited_words <<< "$PROHIBITED_WORDS"

# Прочитать сообщение коммита
commit_message=$(cat "$1")

# Вывод отладочной информации
#echo "Текст коммита, который будет проверен: '$commit_message'"

# Функция для проверки на наличие запрещенных слов
contains_prohibited_word=false
for word in "${prohibited_words[@]}"; do
  if [[ "$commit_message" == *"$word"* ]]; then
    contains_prohibited_word=true
    break
  fi
done

# Проверить правильность формата коммита
# Упрощаем регулярное выражение
regex="^(feat|fix)\((FKIS|COMMON)-[0-9]{4}\): .+"

if [[ ! $commit_message =~ $regex ]]; then
  echo "Некорректный текст коммита."
  echo "Необходимый формат: feat(FKIS-0000): текст или fix(FKIS-0000): текст"
  exit 1
elif [[ "$contains_prohibited_word" == true ]]; then
  echo "No-no-no! Текст коммита содержит плохие словечки."
  exit 1
else
  echo "Текст коммита корректный. Ты молодец!"
  exit 0
fi
