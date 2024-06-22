# locale -a
mylocale=en_US.utf8
LC_ALL=$mylocale locale language
LC_ALL=$mylocale locale charmap
LC_ALL=$mylocale locale int_curr_symbol
LC_ALL=$mylocale locale int_prefix

cat > /etc/locale.conf << "EOF"
LANG="en_US.utf8"
EOF



cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# End /etc/profile
EOF