DCS-SRS Exports Folder
=======================

This folder contains exported client connection data if CLIENT_EXPORT_ENABLED=true.

Typical contents:
- clients-list.json → JSON-formatted list of all currently connected users

This export is intended for use by external scripts, monitoring dashboards, or GCI tools that want to track active users.

The file will be updated periodically by the running server and does not need to be created manually.
