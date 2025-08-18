import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick

Item {
    id: thumbnailContainer

    property string wallpaperPath: ""
    property int cellWidth: 220
    property int cellHeight: 140

    Rectangle {
        id: loadingIndicator
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.4, 32)
        height: Math.min(parent.height * 0.4, 32)
        radius: Appearance.rounding.windowRounding
        color: Appearance.colors.colLayer3
        visible: thumbnailImage.status !== Image.Ready
        opacity: 0.3

        // Loading animation
        SequentialAnimation on opacity {
            running: parent.visible
            loops: Animation.Infinite
            NumberAnimation {
                to: 1.0
                duration: 800
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 0.3
                duration: 800
                easing.type: Easing.InOutSine
            }
        }
    }

    Image {
        id: thumbnailImage
        anchors.fill: parent
        source: `file://${wallpaperPath}`
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true

        sourceSize.width: Math.min(128, cellWidth - 16)
        sourceSize.height: Math.min(96, cellHeight - 16)

        mipmap: false

        opacity: status === Image.Ready ? 1 : 0
        Behavior on opacity {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }
    }
}
