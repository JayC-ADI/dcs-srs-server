DCS-SRS Data Folder
====================

This folder stores persistent runtime configuration and control files used by the DCS-SRS server.

Contents may include:

- banned.txt
  A list of banned client IP addresses. One IP per line.
  This file is automatically created when a client is banned via the REST API or internal logic.
  You may manually edit this file to remove IPs (restart the server afterward to apply changes).

- awacs-radios-custom.json
  Optional static radio definitions for External AWACS Mode (EXTERNAL_AWACS_MODE=true).
  This file allows the server to provide predefined radio channel layouts for connected GCI or AWACS operators.

  It must be valid JSON, defining a flat list of radio definitions per coalition.
  Coalition-specific files are not supported — all radios are listed in one array.

  Example structure:

  [
    {
      "enc": false,              // Whether encryption is enabled on this radio (true/false)
      "encKey": 0,               // Encryption key index (0-255); must match between sender and receiver
      "encMode": 0,              // Encryption mode (0 = none, 1 = secure voice, etc.)
      "freqMax": 100.0,          // Maximum tunable frequency (MHz) if using a scrollable range
      "freqMin": 100.0,          // Minimum tunable frequency (MHz)
      "freq": 100.0,             // Active frequency in MHz (e.g., 100.0 = 100 MHz)
      "modulation": 2,           // Modulation type: 1 = AM, 2 = FM, 6 = MIDS
      "name": "SATCOM",          // Display name of the radio
      "secFreq": 0.0,            // Secondary frequency (used for dual-watch modes); 0.0 disables it
      "volume": 1.0,             // Volume level (0.0 = muted, 1.0 = full volume)
      "freqMode": 0,             // Frequency tuning mode: 0 = fixed, 1 = user adjustable
      "volMode": 1,              // Volume control mode: 0 = fixed, 1 = user adjustable
      "expansion": false,        // Whether this is a virtual/expanded radio (usually false)
      "channel": -1,             // Channel index (if mapped to a channelized system); -1 = N/A
      "simul": false,            // Whether the radio can transmit and receive simultaneously
      "rtMode": 2                // Radio type mode: 0 = local-only, 1 = retransmit node, 2 = normal
    },
    {
      "enc": true,
      "encKey": 0,
      "encMode": 1,
      "freqMax": 399.975,
      "freqMin": 225.000,
      "freq": 322.550,
      "modulation": 1,
      "name": "MAIN",
      "secFreq": 0.0,
      "volume": 1.0,
      "freqMode": 1,
      "volMode": 1,
      "expansion": false,
      "channel": -1,
      "simul": false,
      "rtMode": 1
    }
  ]

  Notes:
  - Each object in the array defines a complete radio preset for use by AWACS or GCI clients.
  - If this file is present, it overrides dynamically generated AWACS radios when EXTERNAL_AWACS_MODE is enabled.
  - MIDS radios (modulation = 6) must use a frequency encoded as: (MIDS_Channel * 100_000) + 1_030_000_000 Hz
  - You may include as many radios as needed in the array.

General Notes:
- This folder must be writable by the container or host process.
- If you want persistence of bans or AWACS configs across container restarts, mount this directory as a Docker volume.
- Files in this directory are only used by the server — clients do not need or see them directly.

For full documentation, visit:
  https://github.com/ciribob/DCS-SimpleRadioStandalone