import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 450
    height: 650
    title: "Smart Barcode Generator"

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7
            spacing: 25

                Text {
                    Layout.fillWidth: true
                    text: "📱 Smart Barcode Generator"
                    color: "black"
                    font.pixelSize: 24
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }


            // Input Section
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "white"
                border.color: "#dee2e6"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Enter Text to Encode:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#495057"
                    }

                    TextField {
                        id: inputField
                        Layout.fillWidth: true
                        placeholderText: "Type your text here..."
                        font.pixelSize: 14
                        padding: 12

                        background: Rectangle {
                            radius: 8
                            border.color: inputField.focus ? "#667eea" : "#ced4da"
                            border.width: 2
                            color: "#f8f9fa"
                        }
                    }
                }
            }

            // Symbology Selection
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "white"
                border.color: "#dee2e6"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Select Barcode Type:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#495057"
                    }

                    ComboBox {
                        id: symbologyBox
                        Layout.fillWidth: true
                        model: barcodeGen ? barcodeGen.getSymbologyNames() : []
                        font.pixelSize: 14

                        Component.onCompleted: {
                            if (barcodeGen) {
                                model = barcodeGen.getSymbologyNames()
                            }
                        }

                        background: Rectangle {
                            radius: 8
                            border.color: symbologyBox.pressed ? "#667eea" : "#ced4da"
                            border.width: 2
                            color: "#f8f9fa"
                        }

                        contentItem: Text {
                            text: symbologyBox.currentText
                            font: symbologyBox.font
                            color: "#495057"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                    }
                }
            }

            // Error/Loading Messages
            Text {
                id: errorText
                Layout.fillWidth: true
                text: ""
                color: "#dc3545"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            // Generate Button
            Button {
                Layout.fillWidth: true
                height: 55
                text: "🚀 Generate Barcode"
                font.pixelSize: 18
                font.bold: true

                background: Rectangle {
                    radius: 12
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: parent.pressed ? "#5a67d8" : "#667eea" }

                    }


                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                        if (inputField.text.length === 0) {
                            errorText.text = "⚠️ Please enter some text to generate barcode"
                            errorText.visible = true
                            return
                        }

                        errorText.visible = false
                        loadingText.visible = true

                        let selectedName = symbologyBox.currentText
                        let symbologyCode = barcodeGen.getSymbologyCode(selectedName)
                        console.log("Selected:", selectedName, "Code:", symbologyCode)

                        let img = barcodeGen.generate(inputField.text, symbologyCode) // img is now a QString
                        console.log("check: " + img)

                        loadingText.visible = false

                        if (!img.startsWith("Error")) {
                            barcodeImage.source = img
                            resultSection.visible = true
                            errorText.visible = false
                        } else {
                            console.log("error: " + img)
                            resultSection.visible = false
                            errorText.text = "❌ " + img.substring(img.indexOf(":") + 2) // Extract the message after "Error: "
                            errorText.visible = true
                        }
                    }
            }



            Text {
                id: loadingText
                Layout.fillWidth: true
                text: "🔄 Generating barcode..."
                color: "#667eea"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            // Error/Loading Messages
            Text {
                id: inputErrorText
                Layout.fillWidth: true
                text: ""
                color: "#dc3545"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            // Result Section
            Rectangle {
                id: resultSection
                Layout.fillWidth: true
                height: 320
                radius: 12
                color: "white"
                border.color: "#dee2e6"
                border.width: 1
                visible: false

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Generated Barcode:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#495057"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 250
                        radius: 8
                        color: "#f8f9fa"
                        border.color: "#dee2e6"
                        border.width: 1

                        Image {
                            id: barcodeImage
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 20, 230)
                            height: Math.min(parent.height - 20, 230)
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }
    }
}
