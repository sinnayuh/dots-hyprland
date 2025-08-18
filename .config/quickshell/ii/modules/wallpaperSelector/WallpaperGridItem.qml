import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls

Item {
    id: gridItem

    property string wallpaperPath: ""
    property bool isSelected: false
    property bool isHovered: false

    signal clicked(bool isRightClick)
    signal hoverChanged(bool hovered)

    Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.windowRounding
        color: Appearance.colors.colLayer1
        border.width: (gridItem.isSelected || gridItem.isHovered) ? 3 : 0
        border.color: Appearance.colors.colSecondary
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        color: Appearance.colors.colLayer2
        radius: Appearance.rounding.windowRounding

        WallpaperThumbnail {
            id: thumbnail
            anchors.fill: parent
            wallpaperPath: gridItem.wallpaperPath
            cellWidth: gridItem.width
            cellHeight: gridItem.height
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onEntered: {
            gridItem.isHovered = true;
            gridItem.hoverChanged(true);
        }

        onExited: {
            gridItem.isHovered = false;
            gridItem.hoverChanged(false);
        }

        onClicked: mouse => {
            gridItem.clicked(mouse.button === Qt.RightButton);
        }
    }
}
