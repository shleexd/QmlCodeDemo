import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: pageBackground
    visible: true
    width: 540
    height:780
    title: qsTr("Hello World")
    color: "black"

    Flickable{
        id:flck
        anchors.fill: parent
        contentWidth: source.width
        contentHeight: source.height
        property real preContentX: contentX
        property real preContentY: contentY
        onMovementEnded: {
            myArea.selectedAreaX = (forSaveCanvas.framX + flck.contentX) / myArea.globelScale
            myArea.selectedAreaY = (forSaveCanvas.framY + flck.contentY) / myArea.globelScale
            console.log("selectedAreaX " + myArea.selectedAreaX)
            console.log("selectedAreaY " + myArea.selectedAreaY)
        }

        Image {
            id: source
            property real initWidth: width
            property real initHeight: height
            source: "qrc:/img.png"
        }
        MouseArea{
            id: myArea
            property real selectedAreaX: 80
            property real selectedAreaY: 200
            property real selectedWidth:forSaveCanvas.width - 2 * 80
            property real selectedHeight:forSaveCanvas.height - 2 * 200
            property real myscale: 1.2
            property real globelScale: 1
            anchors.fill: parent
            onClicked: {
                forSaveCanvas.clipReady = true
                forSaveCanvas.requestPaint()
            }
            onWheel: {
                globelScale *= myscale
                source.width = globelScale * source.initWidth
                source.height = globelScale * source.initHeight
                console.log("source width " + source.width)
                console.log("source height " + source.height)
                selectedAreaX = (forSaveCanvas.framX + flck.contentX) / globelScale
                selectedAreaY = (forSaveCanvas.framY + flck.contentY) / globelScale
                console.log("selectedAreaX " + selectedAreaX)
                console.log("selectedAreaY " + selectedAreaY)
            }
        }
    }
    Canvas{
        id:forSaveCanvas
        anchors.fill:parent
        property real framX: 80
        property real framY: 200
        property real framWidth:width - 2 * 80
        property real framHeight:height - 2 * 200
        property bool clipReady: false
        Image {
            id:forSaveSource
            visible: false
            source: "qrc:/img.png"
        }
        onPaint: {
            var ctx = getContext("2d")
            if(clipReady){
                console.log( myArea.selectedAreaX, myArea.selectedAreaY,
                            myArea.selectedWidth, myArea.selectedHeight,
                            framX, framY, framWidth, framHeight)
                ctx.drawImage(forSaveSource, myArea.selectedAreaX, myArea.selectedAreaY,
                              myArea.selectedWidth, myArea.selectedHeight,
                              framX, framY, framWidth, framHeight)
                source.visible = false
            }
            ctx.fillStyle = "#a0000000"
            ctx.beginPath()
            ctx.rect(0, 0, parent.width, framY)
            ctx.rect(0, framY, framX, framHeight)
            ctx.rect(framX + framWidth, framY, framX, framHeight)
            ctx.rect(0, framY + framHeight, parent.width, framY )
            ctx.fill()
        }
        Component.onCompleted: requestPaint()
    }
}
