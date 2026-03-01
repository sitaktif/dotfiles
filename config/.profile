[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
# BEGIN ANSIBLE MANAGED BLOCK
if [[ -d /home/sitaktif/.config/rc.d ]]; then
  for f in /home/sitaktif/.config/rc.d/*; do
    . "$f"
  done
fi
# END ANSIBLE MANAGED BLOCK
