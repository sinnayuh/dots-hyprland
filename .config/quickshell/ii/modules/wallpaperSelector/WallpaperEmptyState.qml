import qs.modules.common
import qs.modules.common.widgets
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: emptyState

    implicitHeight: noWallpapersLabel.implicitHeight
    implicitWidth: noWallpapersLabel.implicitWidth

    Label {

        id: noWallpapersLabel
        text: "No wallpapers found"
        font.family: Appearance.font.family.main
        font.pixelSize: Appearance.font.pixelSize.normal
        color: Appearance.colors.colSubtext
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }
}
