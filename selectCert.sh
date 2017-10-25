for SQLITEDBPATH in ~/Library/Developer/CoreSimulator/Devices/*/data/Library/Keychains/TrustStore.sqlite3
do
if [ -f "$SQLITEDBPATH" ]; then
sqlite3 "$SQLITEDBPATH" <<EOF
SELECT count(*) FROM tsettings WHERE sha1 = X'44692D2B43E2458197DE96BCAF46301F0DDC56C9';
EOF
fi
done
