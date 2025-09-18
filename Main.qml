import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 500
    title: "Smart Barcode Generator"

    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: inputField
            placeholderText: "Enter text"
            width: parent.width * 0.8
        }

        Button {
            text: "Generate QR Code"
            onClicked: {
                let img = barcodeGen.generate(inputField.text, 58) // 58 = QR Code
                barcodeImage.source = img
            }
        }

        Image {
            id: barcodeImage
            width: 250
            height: 250
            fillMode: Image.PreserveAspectFit
        }
    }
}
