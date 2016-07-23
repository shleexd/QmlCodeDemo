import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id:window
    visible: true
    width: 800
    height: 860
    color: "black"
    Flickable{
        width: Math.min(parent.width, img.width)
        height:Math.min(parent.height, img.height)
        contentWidth: img.width
        contentHeight: img.height
        contentItem.y: (window.height - height) / 2
        contentItem.x: (window.width - width) / 2
        MouseArea{
            anchors.fill: parent
            onClicked: {
                img.width *= 1.2
                img.height *= 1.2
            }
        }

        Image {
            id: img
//            width: window.width
            width: Math.min(window.width, refRetio.width)
            height: width / refRetio.retio
            source: "qrc:/logo.png"
        }
    }
    Image{
        id:refRetio
        property real retio: width / height
        visible: false
        source: "qrc:/logo.png"
    }
}
