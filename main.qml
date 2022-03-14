import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.qmlmodels

ApplicationWindow {
    property color appbgcolor: "#4f4f4f"
    property color apptextcolor: "#e5e5e5"

    id: window
    width: 640
    height: 480
    visible: true
    color: appbgcolor
    title: qsTr("Deliverable Browser")

    menuBar: MenuBar {

        delegate: MenuBarItem {
            id: menuBarItem

            contentItem: Text {
                text: menuBarItem.text
                font: menuBarItem.font
                opacity: 1
                color: window.apptextcolor
            }
            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 30
                opacity: enabled ? 1 : 0.3
                color: menuBarItem.highlighted ? "#5f5f5f" : window.appbgcolor
            }
        }
        background: Rectangle {
            anchors.fill: parent
            color: window.color
        }
        Menu {
            title: qsTr("&Query")
            Action { text: qsTr("&New Query") }
            Action { text: qsTr("&Clear Query") }
            Action { text: qsTr("&Load Query") }
            Action { text: qsTr("&Save Query") }
        }

        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&Get Help") }
            Action { text: qsTr("&About") }
        }
    }
    RowLayout {
        id: searchBar
        y: 0
        height: 60
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 6
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Rectangle {
            id: searchRect
            color: "#1d1d1d"
            radius: 10
            border.width: 2
            Layout.fillWidth: true
            Layout.minimumHeight: 30
            Layout.maximumHeight: 30
            Layout.leftMargin: 40
            Layout.minimumWidth: 90


            TextInput {
                id: searchText
                color: appbgcolor //"#e5e5e5"
                text: qsTr("Text Input")
                anchors.fill: parent
                font.pixelSize: 12
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.topMargin: 8
            }
        }

        RoundButton {
            id: clearButton
            antialiasing: true
            Layout.rightMargin: 0
            Layout.leftMargin: -40
            radius: 10;
            icon.source: "file://home/jgerber/src/qtquick-python/qtcreatorpy/icons/x.svg"
            //icon.source: "qrc:/icons/refresh.svg"
            icon.color: clearButton.down ? "#aaaaaa" : (clearButtonMouseArea.containsMouse ? "#ffffff" : "#cccccc")
            icon.width: 20
            icon.height: 20
            onClicked: {
                searchText.text = ""
            }

            background: Rectangle {
                anchors.fill: parent
                color: parent.down ? "#444444" : "#6a6a6a"
                opacity: 0
                radius: parent.radius
                MouseArea {
                    id: clearButtonMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                }
            }

        }
        RoundButton {
            id: searchButton
            //text: qsTr("Button")
            antialiasing: true
            Layout.rightMargin: 10
            Layout.leftMargin: 10
            radius: 10;
            icon.source: "file://home/jgerber/src/qtquick-python/qtcreatorpy/icons/refresh.svg"
            //icon.source: "qrc:/icons/refresh.svg"
            icon.color: "#cccccc"
            icon.width: 20
            icon.height: 20


            background: Rectangle {
                anchors.fill: parent
                color: parent.down ? "#444444" : "#6a6a6a"
                opacity: searchButtonMouseArea.containsMouse ? 1 : 0
                radius: parent.radius
                MouseArea {
                    id: searchButtonMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

        }
    }

    Row {
        id: footerRow
        y: 458
        height: 22
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Rectangle {
            id: footerRect
            color: appbgcolor //"#4f4f4f"
            //anchors.fill: parent
        }
    }

    Rectangle {
        id: bodyRect
        z: 100
        color: "#4f4f4f"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: searchBar.bottom
        anchors.bottom: footerRow.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        clip: true

        Rectangle {
            id: bodyRectInner
            color: "#1d1d1d"
            anchors.fill: parent
            anchors.rightMargin: 6
            anchors.leftMargin: 6
            HorizontalHeaderView {
                id: horizontalHeader
                z: 1
                height: 20
                syncView: tableView
                anchors.left:tableView.left

                delegate: tableviewHeaderDelegateComponent
            }

            TableView {
                property  double row_height: 30
                id: tableView
                anchors.fill: parent
                anchors.topMargin: row_height + 1
                columnSpacing: 1
                rowSpacing: 1
                clip: true

                model: MyModel

                selectionModel: ItemSelectionModel {
                    model: tableView.model
//                    onCurrentChanged: function (current, prev) {
//                        console.log("current changed: " + current)
//                    }
                    onSelectionChanged: function (sel, des) {
                        console.log("changed")
                    }

                }

                property int selected_row : -1;


                delegate: tableviewDelegateComponent


                columnWidthProvider: function (col) {
                    //console.log("col ", col, " size ", tableView.model.columnSize(col))
                    return tableView.model.columnSize(col)
                }
            }

        }
    }

    Connections {
        target: tableView.selectionModel
        function onCurrentChanged(current, prev) {
            console.log("current changed: " + current)

        }
    }

    Component {
        id: tableviewHeaderDelegateComponent
        Rectangle {
            id: tableviewHeaderDelegate
            //implicitWidth: tableView.columnWidthProvider(index)
            implicitHeight: tableView.row_height
            color: "#444444"
            border.width: 1
            Text {
                text: display
                //anchors.centerIn: parent
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: "#cccccc"
            }
        }
    } // end component


    Component {
        id: tableviewDelegateComponent
        Rectangle {
            id: tableviewDelegate
            implicitWidth: tableView.columnWidthProvider(index)
            implicitHeight: tableView.row_height
            //color: index.row === tableView.selected ? "orange" : "#222222"
            color: selected ? "orange" : "#222222"
            border.width: 1

            required property bool selected

            Text {
                text: display
                //anchors.centerIn: parent
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: "#cccccc"
            }

            MouseArea {
                id: delma
                anchors.fill: parent
                onClicked: function (mouse) {
                    var mp = tableView.mapFromItem(delma, mouse.x, mouse.y)
                    var cell = tableView.cellAtPos(mp.x, mp.y, false)

                    tableView.selected_row = cell.y
                    console.log("mouse.x " +mouse.x + " mouse.y "+ mouse.y + " cell.x " + cell.x+" cell y " + cell.y)
                    console.log("parent selected row " + tableView.selected_row)
                    //midx = tableView.modelIndex(cell.x, cell.y)
                    parent.selected = !parent.selected


                }
            }
        }

    } // end component

}

