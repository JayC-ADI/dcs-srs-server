DCS-SRS Server-Side Presets
============================

This folder holds optional server-side radio presets for DCS-SRS clients.

Enable them by setting:
  SERVER_SIDE_PRESETS_ENABLED=true
in your Docker or server config.

Each file in this directory must follow the format:

  Label|Frequency

Example (each line defines one channel):
  Tower|251.000
  Ground|249.500
  Approach|250.800

Notes:
- Frequency is in MHz (decimal)
- Label must not contain the pipe character (|)
- Spaces are allowed in the label
- File extension should be .txt
- Files must reside in this 'Presets/' directory alongside server.cfg
- File *name* (excluding extension) is what clients will see as the preset name

Clients will receive these presets automatically on connect.

Documentation:
  https://github.com/ciribob/DCS-SimpleRadioStandalone
