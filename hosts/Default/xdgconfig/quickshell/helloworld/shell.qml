import QtQuick
import QtQuick.Window
import Quickshell

ShellRoot {
    id: root

    property int value:.liveValue

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.testBool = !root.testBool
            console.log("parent:", root.testBool)
        }
    }

    Loader {
        id: loader

        sourceComponent: Component {
            Child {
                someProp: root.value
            }
        }
    }
}
