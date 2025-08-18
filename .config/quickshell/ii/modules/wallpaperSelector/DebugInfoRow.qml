import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls

Label {
    property string label: ""
    property var value: ""

    text: `${label}: ${value}`
    font.family: Appearance.font.family.main
    font.pixelSize: Appearance.font.pixelSize.small
    color: Appearance.colors.colPrimary
}
