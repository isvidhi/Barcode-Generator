import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import QtCore

ApplicationWindow {
    visible: true
    width: 450
    height: 800
    title: "Smart Barcode Generator"
    color: "#1F2937"

    property real scaleFactor: Math.min(width / 450, height / 800)
    // Connect to the C++ signal to receive error messages
    Component.onCompleted: {
        barcodeGen.errorOccurred.connect(function(message) {
            errorText.text = "❌ " + message
            errorText.visible = true
            loadingText.visible = false
            resultSection.visible = false
        })
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9  // Changed from 0.8 to 0.9 for better mobile view
            spacing: 20 * scaleFactor  // Changed from 25

            Item {
                Layout.fillWidth: true
                height: 20
            }

            Text {
                Layout.fillWidth: true
                text: "📱Barcode Generator"
                color: "#F9FAFB"
                font.pixelSize: 24
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            // Input Section
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10

                    Text {
                        text: "Enter Text to Encode:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F9FAFB"
                    }

                    TextField {
                        id: inputField
                        Layout.fillWidth: true
                        placeholderText: "Type your text here..."
                        placeholderTextColor: "#808080"
                        font.pixelSize: 14
                        padding: 15
                        color: "#111827"

                        background: Rectangle {
                            radius: 8
                            border.color: inputField.focus ? "#059669" : "#D1D5DB"
                            border.width: 2
                            color: "#F9FAFB"
                        }
                    }
                }
            }

            // Symbology Selection
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Select Barcode Type:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F9FAFB"
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
                            border.color: symbologyBox.pressed ? "#059669" : "#D1D5DB"
                            border.width: 2
                            color: "#F9FAFB"
                        }

                        contentItem: Text {
                            text: symbologyBox.currentText
                            font: symbologyBox.font
                            color: "#111827"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                    }
                }
            }

            // Rotation Selection
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Select Rotation:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F9FAFB"
                    }

                    ComboBox {
                        id: rotationBox
                        Layout.fillWidth: true
                        model: ["0° (No Rotation)", "90° (Rotate Right)", "180° (Upside Down)", "270° (Rotate Left)"]
                        font.pixelSize: 14

                        background: Rectangle {
                            radius: 8
                            border.color: rotationBox.pressed ? "#059669" : "#D1D5DB"
                            border.width: 2
                            color: "#F9FAFB"
                        }

                        contentItem: Text {
                            text: rotationBox.currentText
                            font: rotationBox.font
                            color: "#111827"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                    }
                }
            }

            // HRT Toggle Section
            Rectangle {
                Layout.fillWidth: true
                height: 80
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Show Human Readable Text:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F9FAFB"
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: hrtSwitch
                        checked: false

                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            x: hrtSwitch.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 13
                            color: hrtSwitch.checked ? "#10B981" : "#6B7280"

                            Rectangle {
                                x: hrtSwitch.checked ? parent.width - width - 2 : 2
                                y: 2
                                width: 22
                                height: 22
                                radius: 11
                                color: "white"
                            }
                        }
                    }
                }
            }

            // Size Controls Section
            Rectangle {
                Layout.fillWidth: true
                height: 180
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "Barcode Size:"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F9FAFB"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Height:"
                            font.pixelSize: 14
                            color: "#F9FAFB"
                        }

                        TextField {
                            id: heightField
                            Layout.fillWidth: true
                            text: "50"
                            placeholderText: "Height (default: 50)"
                            placeholderTextColor: "#808080"
                            font.pixelSize: 14
                            padding: 8
                            color: "#111827"

                            background: Rectangle {
                                radius: 8
                                border.color: heightField.focus ? "#059669" : "#D1D5DB"
                                border.width: 2
                                color: "#F9FAFB"
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Width:"
                            font.pixelSize: 14
                            color: "#F9FAFB"
                        }

                        TextField {
                            id: widthField
                            Layout.fillWidth: true
                            text: "0"
                            placeholderText: "Width (0 = auto)"
                            placeholderTextColor: "#808080"
                            font.pixelSize: 14
                            padding: 8
                            color: "#111827"

                            background: Rectangle {
                                radius: 8
                                border.color: widthField.focus ? "#059669" : "#D1D5DB"
                                border.width: 2
                                color: "#F9FAFB"
                            }
                        }
                    }
                }
            }

            Text {
                id: errorText
                Layout.fillWidth: true
                text: ""
                color: "#EF4444"
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
                    radius: 8
                    color: "#006A67"
                    border.width: 0
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "#D1D3D4"
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
                    downloadButton.enabled = false

                    let selectedName = symbologyBox.currentText
                    let textToEncode = inputField.text
                    let rotationAngle = rotationBox.currentIndex * 90
                    let showHrt = hrtSwitch.checked ? 1 : 0
                    let height = heightField.text
                    let width = widthField.text

                    // Set the image source with all parameters
                    barcodeImage.source = "image://barcode/" + textToEncode + "/" + selectedName + "/" + rotationAngle + "/" + showHrt + "/" + height + "/" + width
                }
            }

            Text {
                id: loadingText
                Layout.fillWidth: true
                text: "🔄 Generating barcode..."
                color: "#059669"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                visible: false
            }

            // Result Section
            Rectangle {
                id: resultSection
                Layout.fillWidth: true
                height: 400
                radius: 12
                color: "#374151"
                border.color: "#D1D5DB"
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
                        color: "#F9FAFB"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 250
                        radius: 8
                        color: "#F9FAFB"
                        border.color: "#D1D5DB"
                        border.width: 1

                        Image {
                            id: barcodeImage
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 20, 230)
                            height: Math.min(parent.height - 20, 230)
                            fillMode: Image.PreserveAspectFit

                            onStatusChanged: {
                                if (status === Image.Ready) {
                                    loadingText.visible = false
                                    resultSection.visible = true
                                    errorText.visible = false
                                    downloadButton.enabled = true
                                } else if (status === Image.Error) {
                                    loadingText.visible = false
                                    resultSection.visible = false
                                    downloadButton.enabled = false
                                }
                            }
                        }
                    }

                    Button {
                        id: downloadButton
                        Layout.fillWidth: true
                        height: 45
                        text: "💾 Download Barcode"
                        font.pixelSize: 16
                        font.bold: true
                        enabled: false

                        background: Rectangle {
                            radius: 8
                            color: parent.enabled ? (parent.pressed ? "4FB7B3" : "#10B981") : "#D1D5DB"
                            border.width: 0
                        }

                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            color: parent.enabled ? "white" : "#6B7280"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            let selectedName = symbologyBox.currentText
                            let textToEncode = inputField.text
                            let rotationAngle = rotationBox.currentIndex * 90
                            let showHrt = hrtSwitch.checked ? 1 : 0
                            let height = heightField.text
                            let width = widthField.text

                            // Store current settings for save dialog
                            folderDialog.currentText = textToEncode
                            folderDialog.currentSymbology = selectedName
                            folderDialog.currentRotation = rotationAngle
                            folderDialog.currentHrt = showHrt
                            folderDialog.currentHeight = height
                            folderDialog.currentWidth = width

                            folderDialog.open()
                        }
                    }

                    Text {
                        id: downloadSuccessText
                        Layout.fillWidth: true
                        text: "✅ Barcode saved successfully!"
                        color: "#22C55E"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        visible: false
                    }

                    Timer {
                        id: downloadSuccessTimer
                        interval: 3000
                        repeat: false
                        onTriggered: {
                            downloadSuccessText.visible = false
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 30
            }
        }
    }

    FolderDialog {
            id: folderDialog
            title: "Select folder to save barcode"

            // Store current barcode settings
            property string currentText: ""
            property string currentSymbology: ""
            property int currentRotation: 0
            property int currentHrt: 0
            property string currentHeight: ""
            property string currentWidth: ""

            onAccepted: {
                let folderPath = selectedFolder.toString()

                // Create filename with timestamp
                let timestamp = Qt.formatDateTime(new Date(), "yyyyMMdd_hhmmss")
                let filename = folderPath + "/barcode_" + timestamp + ".png"

                let result = barcodeGen.saveBarcodeToPath(
                    currentText,
                    currentSymbology,
                    currentRotation,
                    currentHrt,
                    currentHeight,
                    currentWidth,
                    filename
                )

                if (result) {
                    downloadSuccessText.visible = true
                    downloadSuccessTimer.restart()
                }
            }
        }

    // File Save Dialog
    // FileDialog {
    //     id: saveDialog
    //     title: "Save Barcode"
    //     fileMode: FileDialog.SaveFile
    //     nameFilters: ["PNG files (*.png)", "All files (*)"]
    //     defaultSuffix: "png"
    //     currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

    //     // Store current barcode settings
    //     property string currentText: ""
    //     property string currentSymbology: ""
    //     property int currentRotation: 0
    //     property int currentHrt: 0
    //     property string currentHeight: ""
    //     property string currentWidth: ""

    //     onAccepted: {
    //         let filePath = saveDialog.selectedFile.toString()
    //         // Remove "file://" prefix
    //         if (filePath.startsWith("file://")) {
    //             filePath = filePath.substring(7)
    //         }

    //         let result = barcodeGen.saveBarcodeToPath(
    //             currentText,
    //             currentSymbology,
    //             currentRotation,
    //             currentHrt,
    //             currentHeight,
    //             currentWidth,
    //             filePath
    //         )

    //         if (result) {
    //             downloadSuccessText.visible = true
    //             downloadSuccessTimer.restart()
    //         }
    //     }
    // }
}
