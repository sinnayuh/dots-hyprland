import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls

TextField {
    id: searchField

    property bool previewMode: false

    signal filterChanged(string text)
    signal navigationRequested(string direction)
    signal activateRequested
    signal closeRequested

    implicitHeight: 40
    implicitWidth: Appearance.sizes.searchWidth
    padding: 10
    placeholderText: "Search wallpapers..."
    placeholderTextColor: Appearance.colors.colSubtext
    color: Appearance.colors.colPrimary
    background: Rectangle {
        color: Appearance.colors.colLayer0
        border.color: Appearance.colors.colLayer0Border
        border.width: 1
        radius: Appearance.rounding.small
    }
    font.family: Appearance.font.family.main
    font.pixelSize: Appearance.font.pixelSize.normal
    enabled: !previewMode

    Component.onCompleted: {
      if (visible) {
        forceActiveFocus();
        searchField.forceActiveFocus();
      }
    }
    function clearFilter() {
        text = "";
    }

    onTextChanged: {
        filterChanged(text);
    }

    Keys.onPressed: event => {
        if (previewMode)
            return;

        if (text.length === 0) {
            if (event.key === Qt.Key_Down || event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
                if (event.key === Qt.Key_Down)
                    navigationRequested("down");
                else if (event.key === Qt.Key_Left)
                    navigationRequested("left");
                else if (event.key === Qt.Key_Right)
                    navigationRequested("right");
                event.accepted = true;
            }
        } else {
            if (event.key === Qt.Key_Down) {
                navigationRequested("down");
                event.accepted = true;
            }
        }

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            activateRequested();
            event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
            if (text.length > 0) {
                text = "";
            } else {
                closeRequested();
            }
            event.accepted = true;
        }
    }
}
