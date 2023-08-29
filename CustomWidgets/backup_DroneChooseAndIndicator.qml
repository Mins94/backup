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

    readonly property string noGPS:         qsTr("NO GPS")
    readonly property real   indicatorValueWidth:   ScreenTools.defaultFontPixelWidth * 7

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property string _altitude:              _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _distanceStr:           isNaN(_distance) ? "0" : _distance.toFixed(0) + ' ' + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property real   _heading:               _activeVehicle   ? _activeVehicle.heading.rawValue : 0
    property real   _distance:              _activeVehicle ? _activeVehicle.distanceToHome.rawValue : 0
    property string _messageTitle:          ""
    property string _messageText:           ""
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75

    //Vehicle.cc 참고
    property real _vehicleAltitude_rel:     _activeVehicle ? _activeVehicle.altitudeRelative.rawValue : 0
//    property real _vehicleAltitude_AMSL:    _activeVehicle ? _activeVehicle.altitudeAMSL.rawValue : 0
    property real _vehicleAltitude_AMSL:    _activeVehicle ? vehicle0.altitudeAMSL.rawValue : 0
    property string _altitude_relStr:       _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _altitude_AMSLStr:      _activeVehicle ? (isNaN(_activeVehicle.altitudeAMSL.value) ? "0.0" : _activeVehicle.altitudeAMSL.value.toFixed(1)) + ' ' + _activeVehicle.altitudeAMSL.units : "0.0"

    property real _airspeed:                _activeVehicle ? _activeVehicle.airSpeed.rawValue : 0
    property real _flightTime:              _activeVehicle ? _activeVehicle.flightTime.rawValue : 0
    property real _groundSpeed:             _activeVehicle ? _activeVehicle.groundSpeed.rawValue : 0
    property string _groundSpeedStr:        _activeVehicle ? (isNaN(_activeVehicle.groundSpeed.value) ? "0.0" : _activeVehicle.groundSpeed.value.toFixed(1)) + ' ' + _activeVehicle.groundSpeed.units : "0.0"

//    property real _groundSpeed:         vehicle ? vehicle.groundSpeed.rawValue : 0
    property real _rollAngle:   _activeVehicle ? vehicle.roll.rawValue  : 0
    property real _pitchAngle:  _activeVehicle ? vehicle.pitch.rawValue : 0

    //define property for each vehicles
/*
    property var vehicle0: QGroundControl.multiVehicleManager.getVehicleById(0)
    property var vehicle1: QGroundControl.multiVehicleManager.getVehicleById(1)
    property var vehicle2: QGroundControl.multiVehicleManager.getVehicleById(2)
*/
//    property var vehicle0 : QGroundControl.multiVehicleManager.getVehicleById(0);
    property var    _vehicle:   object

    property var vehicle0: _getVehicleById(0)
    property var vehicle1: _getVehicleById(1)
    property var vehicle2: _getVehicleById(2)

    function _getVehicleById(vehicleId) {
        for (var i = 0; i < QGroundControl.multiVehicleManager.vehicles.count; i++) {
            var vehicle = QGroundControl.multiVehicleManager.vehicles[i];
            if (vehicle.id === vehicleId) {
                return vehicle0;
            }
        }
        return null;
    }


    //property for vehicle0

    property real _vehicleAltitude_AMSL1:       vehicle0 ? vehicle0.altitudeAMSL.rawValue : 0
    property real _airspeed1:                   vehicle0 ? vehicle0.airSpeed.rawValue : 0
    property real _flightTime1:                 vehicle0 ? vehicle0.flightTimeFact.rawValue : 0
    property real _groundSpeed1:                vehicle0 ? vehicle0.groundSpeed.rawValue : 0
    property real _flightdistance1:             vehicle0 ? vehicle0.flightDistance.rawValue : 0
    property real _climbrate1:                  vehicle0 ? vehicle0.climbRate.rawValue : 0

    property string _altitude_AMSLStr1:         vehicle0 ? (isNaN(vehicle0.altitudeAMSL.value) ? "0.0" : vehicle0.altitudeAMSL.value.toFixed(1)) + ' ' + vehicle0.altitudeAMSL.units : "0.0"
    property string _airspeedStr1:              vehicle0 ? (isNaN(vehicle0.airSpeed.value) ? "0.0" : vehicle0.airSpeed.value.toFixed(1)) + ' ' + vehicle0.airSpeed.units : "0.0"
    property string _flightTimeStr1:            vehicle0 ? (isNaN(vehicle0.flightTimeFact.value) ? "0.0" : vehicle0.flightTimeFact.value.toFixed(1)) + ' ' + vehicle0.flightTimeFact.units : "0.0"
    property string _groundSpeedStr1:           vehicle0 ? (isNaN(vehicle0.groundSpeed.value) ? "0.0" : vehicle0.groundSpeed.value.toFixed(1)) + ' ' + vehicle0.groundSpeed.units : "0.0"
    property string _flightdistanceStr1:        vehicle0 ? (isNaN(vehicle0.flightDistance.value) ? "0.0" : vehicle0.flightDistance.value.toFixed(1)) + ' ' + vehicle0.flightDistance.units : "0.0"
    property string _climbrateStr1:             vehicle0 ? (isNaN(vehicle0.climbRate.value) ? "0.0" : vehicle0.climbRate.value.toFixed(1)) + ' ' + vehicle0.climbRate.units : "0.0"



/*

        + "비행거리:" + _altitude_AMSLStr + "[m]" + "\n"
        + "지상속도:" + _altitude_AMSLStr + "[m/s]" + "\n"
        + "배터리량:" + _altitude_AMSLStr + "[%]"

*/

    Rectangle {
        id:                     droneChooseAndIndicator
        anchors.bottomMargin:   _toolsMargin
        anchors.rightMargin:    _toolsMargin
        anchors.bottom:        parent.bottom
//        anchors.left:          parent.left
//        anchors.right:          parent.right
        anchors.fill:   gridforinformation

        width: 790
        height: 110
//        color: "grey"
//        border.color: "grey"
//        border.width: 10
        opacity: 0.8
        Grid{
        id:gridforinformation
        anchors.centerIn: parent
        columns: 3
        rows: 1
        spacing: 10

        Rectangle{
            id : drone1
            width:250
            height:100
            color: "#FFF291"
            opacity: 0.8

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

            }

        Rectangle{
            id : drone2
            width:250
            height:100
            color: "#FFFFFF"
            opacity: 0.8

            Text {
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
                }

            }

        Rectangle{
            id : drone3
            width:250
            height:100
            color: "#F7E0FF"
            opacity: 0.8

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

                }

            }


        }
    }

}
