if ! is-macos -o ! is-executable brew; then
  echo "Skipped: MAS"
  return
fi

mas signin richard.j.roche@gmail.com

# Install packages
# Xcode             497799835
# 1Password         1333542190
# Alfred            405843582
# Amphetamine       937984704
# AppCleaner        1013897218
# EasyFind          411673888
# OneDrive          823766827
# Pocket            568494494
# TextWrangler      404010395
# The Unarchiver    425424353
# Wunderlist        410628904
# Notability        736189492

apps=(
  497799835
  1333542190
  405843582
  937984704
  1013897218
  411673888
  823766827
  568494494
  404010395
  425424353
  410628904
  736189492
)

mas install "${apps[@]}"
