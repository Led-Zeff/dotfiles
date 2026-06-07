pragma Singleton

import Quickshell
import Quickshell.Bluetooth

Singleton {
    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: Bluetooth.adapters.values.length > 0
    readonly property bool enabled: adapter?.enabled ?? false

    function toggleEnabled() {
        adapter.enabled = !adapter.enabled;
    }
}
