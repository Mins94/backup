import QtQuick 2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

Item {

    id: _root


    // property for common

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl

    property real   _margin:            ScreenTools.defaultFontPixelWidth / 2

    readonly property string noGPS:         qsTr("NO GPS")
    readonly property real   indicatorValueWidth:   ScreenTools.defaultFontPixelWidth * 7

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property string _messageTitle:          ""
    property string _messageText:           ""
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75


    //define property for each vehicles
/*
    property var vehicle0: QGroundControl.multiVehicleManager.getVehicleById(0)
    property var vehicle1: QGroundControl.multiVehicleManager.getVehicleById(1)
    property var vehicle2: QGroundControl.multiVehicleManager.getVehicleById(2)
*/
//    property var vehicle0 : QGroundControl.multiVehicleManager.getVehicleById(0);
//    property var    _vehicle:   object

    property var vehicle0: _getVehicleById(0)
    property var vehicle1: _getVehicleById(1)
    property var vehicle2: _getVehicleById(2)

/*
    function _getVehicleById(vehicleId) {
        for (var i = 0; i < QGroundControl.multiVehicleManager.vehicles.count; i++) {
            var vehicle = QGroundControl.multiVehicleManager.vehicles[i];
            if (vehicle.id === vehicleId) {
                return vehicle0;
            }
        }
        return null;
    }*/

    function _getVehicleById(vehicleId) {
        for (var i = 0; i < QGroundControl.multiVehicleManager.vehicles.count; i++) {
            var vehicle = QGroundControl.multiVehicleManager.vehicles[i];
            if(vehicleId === i){return vehicle;}
            if (QGroundControl.multiVehicleManager.vehicles.count === 1) {
                return QGroundControl.multiVehicleManager.activeVehicle;
            }
        }
        return null;
    }


    property var loadvehicles : QGroundControl.multiVehicleManager.vehicles

    property var _vehicletestab :_activeVehicle
    property var _vehicletestab1 : vehicle0

    property int titlefontsize: 12
    property int infofontsize: 25
    property int outboxwidth: (globals.mainwindowwidth/5)*3 + 20
    property int inboxwidth: globals.mainwindowwidth/5 - _margins
    property int width_global : globals.mainwindowwidth/6
    property int outboxheight: width_global*12/25
    property int inboxheight: outboxheight - _margins
//    property int outboxheight: 110
//    property int inboxheight: 100
    property string boxcolor: "#072532"
    property string inboxtextcolor : "#FFFFFF"


    Rectangle {
        id:                     droneChooseAndIndicator
//        anchors.bottomMargin:   _toolsMargin
        anchors.rightMargin:    _toolsMargin
        anchors.bottom:        parent.bottom
//        anchors.left:          parent.left
//        anchors.right:          parent.right
        anchors.fill:   gridforinformation

        width: outboxwidth
        height: outboxheight
        opacity: 0.8
        color:"#104754"

        Grid{
        id:gridforinformation
        anchors.centerIn: droneChooseAndIndicator
        columns: 3
        rows: 1
        spacing: 10

        Rectangle{
            id : drone1
            width:inboxwidth
            height:inboxheight
            color: "#FFF291"
            opacity: 0.8

            RowLayout {
                id : drone1_info
                Layout.fillWidth:       true

                QGCLabel {
                    Layout.alignment:   Qt.AlignTop
                    text:               _vehicletestab ? _vehicletestab.id +"번 \n기체" : + " "+"번 \n기체"
                    font.pointSize: 10 // Adjust the font size here

                    color:              _textColor
                }

                ColumnLayout {
                    Layout.alignment:   Qt.AlignCenter
                    spacing:            _margin

                    FlightModeMenu {
                        Layout.alignment:           Qt.AlignHCenter
//                            font.pointSize:             ScreenTools.largeFontPointSize
                        font.pointSize: 15 // Adjust the font size here
                        color:                      _textColor
                        currentVehicle:             _vehicletestab
                    }

                    QGCLabel {
                        Layout.alignment:           Qt.AlignHCenter
                        font.pointSize: 10 // Adjust the font size here
                        text:                       _vehicletestab && _vehicletestab.armed ? qsTr("Armed") : qsTr("Disarmed")
                        color:                      _textColor
                    }
                }

/*                QGCCompassWidget {
//                      size:       _widgetHeight
                    size:       125
                    usedByMultipleVehicleList: true
                    vehicle:    vehicletest
                }*/

                QGCAttitudeWidget {
//                      size:       _widgetHeight
                    size:       70
                    vehicle:    _vehicletestab
                }
                QGCButton {
                    text:       qsTr("기체선택")
                    leftPadding: 5
                    rightPadding: 5
                    font.pointSize: 12 // Adjust the font size here
                    onClicked: {
                        var vehicleId = 1
                        var vehicle = QGroundControl.multiVehicleManager.getVehicleById(vehicleId)
                        QGroundControl.multiVehicleManager.activeVehicle = vehicle
                    }
                }
            } // RowLayout
            Row {
                id: drone1_control
                anchors.top: drone1_info.bottom

                spacing: ScreenTools.defaultFontPixelWidth/10

                QGCButton {
                    text:       qsTr("Arm")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    _vehicletestab && !_vehicletestab.armed
                    onClicked:  _vehicletestab.armed = true
                }

                QGCButton {
                    text:       qsTr("Start Mission")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    _vehicletestab && _vehicletestab.armed && _vehicletestab.flightMode !== _vehicletestab.missionFlightMode
                    onClicked:  _vehicletestab.startMission()
                }

                QGCButton {
                    text:       qsTr("Pause")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    _vehicletestab && _vehicletestab.armed && _vehicletestab.pauseVehicleSupported
                    onClicked:  _vehicletestab.pauseVehicle()
                }

                QGCButton {
                    text:       qsTr("RTL")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    _vehicletestab && _vehicletestab.armed && _vehicletestab.flightMode !== _vehicletestab.rtlFlightMode
                    onClicked:  _vehicletestab.flightMode = _vehicletestab.rtlFlightMode
                }

                QGCButton {
                    text:       qsTr("Take control")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    _vehicletestab && _vehicletestab.armed && _vehicletestab.flightMode !== _vehicletestab.takeControlFlightMode
                    onClicked:  _vehicletestab.flightMode = _vehicletestab.takeControlFlightMode
                }
            } // Row
/*
            Text {
                id : title1
                text: "1번 기체"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 18 // Adjust the font size here
                font.bold: true // Set the text to bold
//                font.italic: true // Set the text to italic
                font.family: "Helvetica" // Set the font family
                anchors.topMargin: _toolsMargin
                //anchors.top: parent
                //anchors.left: parent.horizontalCenter}
                anchors.left: parent.horizontalCenter}

                Rectangle {
                    id:                     attitudeIndicator1
                    anchors.bottomMargin:   _toolsMargin
                    anchors.rightMargin:    _toolsMargin
                    anchors.left:          parent.left
                    height:                 100
                    width:                  height
                    radius:                 height * 0.5
                    color:                  qgcPal.windowShade

                    QGCAttitudeWidget {
                        size:               parent.height * 0.95
                        vehicle:                vehicle0
                        anchors.verticalCenter: attitudeIndicator1.verticalCenter
                        anchors.horizontalCenter: attitudeIndicator1.horizontalCenter
                    }
                }
*/

            }

        Rectangle{
            id : drone2
            width:inboxwidth
            height:inboxheight
            color: "#FFFFFF"
            opacity: 0.8
            RowLayout {
                id : drone2_info
                Layout.fillWidth:       true

                QGCLabel {
                    Layout.alignment:   Qt.AlignTop
//                    text:               vehicle1 ? vehicle1.id +"번 \n기체" : + " "+"번 \n기체"
                    text:               "2번 \n기체"
                    font.pointSize: 10 // Adjust the font size here

                    color:              _textColor
                }

                ColumnLayout {
                    Layout.alignment:   Qt.AlignCenter
                    spacing:            _margin

                    FlightModeMenu {
                        Layout.alignment:           Qt.AlignHCenter
//                            font.pointSize:             ScreenTools.largeFontPointSize
                        font.pointSize: 15 // Adjust the font size here
                        color:                      _textColor
                        currentVehicle:             vehicle1
                    }

                    QGCLabel {
                        Layout.alignment:           Qt.AlignHCenter
                        font.pointSize: 10 // Adjust the font size here
                        text:                       vehicle1 && vehicle1.armed ? qsTr("Armed") : qsTr("Disarmed")
                        color:                      _textColor
                    }
                }

/*                QGCCompassWidget {
//                      size:       _widgetHeight
                    size:       125
                    usedByMultipleVehicleList: true
                    vehicle:    vehicletest
                }*/

                QGCAttitudeWidget {
//                      size:       _widgetHeight
                    size:       70
                    vehicle:    vehicle1
                }
                QGCButton {
                    text:       qsTr("기체선택")
                    leftPadding: 5
                    rightPadding: 5
                    font.pointSize: 12 // Adjust the font size here
                    onClicked: {
                        var vehicleId = 2
                        var vehicle = QGroundControl.multiVehicleManager.getVehicleById(vehicleId)
                        QGroundControl.multiVehicleManager.activeVehicle = vehicle
                    }
                }
            } // RowLayout
            Row {
                id: drone2_control
                anchors.top: drone2_info.bottom

                spacing: ScreenTools.defaultFontPixelWidth/10

                QGCButton {
                    text:       qsTr("Arm")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle1 && !vehicle1.armed
                    onClicked:  vehicle1.armed = true
                }

                QGCButton {
                    text:       qsTr("Start Mission")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle1 && vehicle1.armed && vehicle1.flightMode !== vehicle1.missionFlightMode
                    onClicked:  vehicle1.startMission()
                }

                QGCButton {
                    text:       qsTr("Pause")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle1 && vehicle1.armed && vehicle1.pauseVehicleSupported
                    onClicked:  vehicle1.pauseVehicle()
                }

                QGCButton {
                    text:       qsTr("RTL")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle1 && vehicle1.armed && vehicle1.flightMode !== vehicle1.rtlFlightMode
                    onClicked:  vehicle1.flightMode = vehicle1.rtlFlightMode
                }

                QGCButton {
                    text:       qsTr("Take control")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle1 && vehicle1.armed && vehicle1.flightMode !== vehicle1.takeControlFlightMode
                    onClicked:  vehicle1.flightMode = vehicle1.takeControlFlightMode
                }
            } // Row
/*            Text {
                id : title2
                text: "2번 기체"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 18 // Adjust the font size here
                font.bold: true // Set the text to bold
                //font.italic: true // Set the text to italic
                font.family: "Gothic" // Set the font family
//                anchors.top: parent
                anchors.topMargin: _toolsMargin
                anchors.left: parent.horizontalCenter}

                Rectangle {
                    id:                     attitudeIndicator2
                    anchors.bottomMargin:   _toolsMargin
                    anchors.rightMargin:    _toolsMargin
                    anchors.left:          parent.left
                    height:                 100
                    width:                  height
                    radius:                 height * 0.5
                    color:                  qgcPal.windowShade

                    QGCAttitudeWidget {
                        size:               parent.height * 0.95
                        vehicle:                vehicle1
                        anchors.verticalCenter: attitudeIndicator2.verticalCenter
                        anchors.horizontalCenter: attitudeIndicator2.horizontalCenter
                    }
                }*/

            }

        Rectangle{
            id : drone3
            width:inboxwidth
            height:inboxheight
            color: "#F7E0FF"
            opacity: 0.8
            RowLayout {
                id : drone3_info
                Layout.fillWidth:       true

                QGCLabel {
                    Layout.alignment:   Qt.AlignTop
//                    text:               vehicle2 ? vehicle2.id +"번 \n기체" : + " "+"번 \n기체"
                    text:               "3번 \n기체"
                    font.pointSize: 10 // Adjust the font size here

                    color:              _textColor
                }

                ColumnLayout {
                    Layout.alignment:   Qt.AlignCenter
                    spacing:            _margin

                    FlightModeMenu {
                        Layout.alignment:           Qt.AlignHCenter
//                            font.pointSize:             ScreenTools.largeFontPointSize
                        font.pointSize: 15 // Adjust the font size here
                        color:                      _textColor
                        currentVehicle:             vehicle2
                    }

                    QGCLabel {
                        Layout.alignment:           Qt.AlignHCenter
                        font.pointSize: 10 // Adjust the font size here
                        text:                       vehicle2 && vehicle2.armed ? qsTr("Armed") : qsTr("Disarmed")
                        color:                      _textColor
                    }
                }

/*                QGCCompassWidget {
//                      size:       _widgetHeight
                    size:       125
                    usedByMultipleVehicleList: true
                    vehicle:    vehicletest
                }*/

                QGCAttitudeWidget {
//                      size:       _widgetHeight
                    size:       70
                    vehicle:    vehicle2
                }
                QGCButton {
                    text:       qsTr("기체선택")
                    leftPadding: 5
                    rightPadding: 5
                    font.pointSize: 12 // Adjust the font size here
                    onClicked: {
                        var vehicleId = 3
                        var vehicle = QGroundControl.multiVehicleManager.getVehicleById(vehicleId)
                        QGroundControl.multiVehicleManager.activeVehicle = vehicle
                    }
                }
            } // RowLayout
            Row {
                id: drone3_control
                anchors.top: drone3_info.bottom

                spacing: ScreenTools.defaultFontPixelWidth/10

                QGCButton {
                    text:       qsTr("Arm")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle2 && !vehicle2.armed
                    onClicked:  vehicle2.armed = true
                }

                QGCButton {
                    text:       qsTr("Start Mission")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle2 && vehicle2.armed && vehicle2.flightMode !== vehicle2.missionFlightMode
                    onClicked:  vehicle2.startMission()
                }

                QGCButton {
                    text:       qsTr("Pause")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle2 && vehicle2.armed && vehicle2.pauseVehicleSupported
                    onClicked:  vehicle2.pauseVehicle()
                }

                QGCButton {
                    text:       qsTr("RTL")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle2 && vehicle2.armed && vehicle2.flightMode !== vehicle2.rtlFlightMode
                    onClicked:  vehicle2.flightMode = vehicle2.rtlFlightMode
                }

                QGCButton {
                    text:       qsTr("Take control")
                    leftPadding: 2
                    rightPadding: 2
                    font.pointSize: 12 // Adjust the font size here
                    visible:    vehicle2 && vehicle2.armed && vehicle2.flightMode !== vehicle2.takeControlFlightMode
                    onClicked:  vehicle2.flightMode = vehicle2.takeControlFlightMode
                }
            } // Row
            /*
            Text {
                id: title3
                text: "3번 기체"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 18 // Adjust the font size here
                font.bold: true // Set the text to bold
                //font.italic: true // Set the text to italic
                font.family: "Arial" // Set the font family
                anchors.topMargin: _toolsMargin
                //anchors.top: parent
                anchors.left: parent.horizontalCenter}
            Text {
                text: "해발고도: " + _altitude_AMSLStr1 + "[m]" + "\n"
                    + "비행거리:" + _flightdistanceStr1 + "[m]" + "\n"
                    + "지상속도:" + _groundSpeedStr1 + "[m/s]" + "\n"
                    + "배터리량:" + _altitude_AMSLStr + "[%]"

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 10 // Adjust the font size here
                font.bold: true // Set the text to bold
                font.family: "Arial" // Set the font family
                anchors.topMargin: _toolsMargin
                anchors.top: title3.bottom
                anchors.left: parent.horizontalCenter
            }
                Rectangle {
                    id:                     attitudeIndicator3
                    anchors.bottomMargin:   _toolsMargin
                    anchors.rightMargin:    _toolsMargin
                    anchors.left:          parent.left
                    height:                 100
                    width:                  height
                    radius:                 height * 0.5
                    color:                  qgcPal.windowShade

                    QGCAttitudeWidget {
                        size:               parent.height * 0.95
                        vehicle:                vehicle2
                        anchors.verticalCenter: attitudeIndicator3.verticalCenter
                        anchors.horizontalCenter: attitudeIndicator3.horizontalCenter
                    }

                } */

            }


        }
    }

}
