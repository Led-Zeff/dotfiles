import Quickshell
import qs.components.widgets
import qs.components.theme

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        right: true
        left: true
      }
      color: 'transparent'
      implicitHeight: clock.implicitHeight

      margins {
        top: Spaces.marginTop
        left: Spaces.marginSides
        right: Spaces.marginSides
      }

      ClockWidget {
        id: clock
        anchors.centerIn: parent
      }

      BluetoothWidget {
        anchors.right: parent.right
      }
    }
  }
}
