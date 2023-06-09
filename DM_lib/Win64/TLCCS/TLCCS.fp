s��         ��     �E  �   �   ����                               tlccs                           Thorlabs CCS VISA Instrument Driver         _VI_FUNC                                                     � ��ViAttrState     
�  	ViUInt32[]     � ��progres_func_t     
�  	ViUInt16[]     � ��ViBuf  � � ��ViInt16  �  � ��ViInt32     � ��ViUInt32  � � ��ViReal64     � ��ViRsrc     	� 	��ViBoolean     	� 	��ViSession     � ��ViStatus     �  ViChar[]     � ��ViChar     � ��ViString     	�  ViInt16[]     	�  ViInt32[]     
�  	ViReal64[]     � 	 
ViBoolean[]     � ��ViUInt16     � ��ViConstString     � ��ViUInt8     � ��ViAttr  h    This instrument driver module provides programming support for the THORLABS CCS Series Spectrometer instruments.

LICENSE:

This software is Copyright � 20013, Thorlabs.

This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
     s    This class of functions groups functions to configure the instrument by setting system configuration parameters.
     �    This class of functions allow the user execute actions on the instrument and to determine the current state of the instrument.     i    This class of functions provides utility and lower level functions to communicate with the instrument.
    N    This function initializes the instrument driver session and performs the following initialization actions:

(1) Opens a session to the Default Resource Manager resource and a session to the specified device using the Resource Name  specified.
(2) Performs an identification query on the instrument.
(3) Resets the instrument to a known state.
(4) Sends initialization commands to the instrument.
(5) Returns an instrument handle which is used to distinguish between different sessions of this instrument driver.

Notes:
(1) Each time this function is invoked a unique session is opened.      U    This parameter specifies the device that is to be initialized (Resource Name). The syntax for this parameter is shown below.

"USB0::0x1313::0x8080::DEVICE-SERIAL-NUMBER::RAW"

For remote VISA sessions use. "VISA://HOSTNAME[:PORT]/USB0::0x1313::0x8080::DEVICE-SERIAL-NUMBER::RAW". 
Where HOSTNAME is the name of the machine running the VISA server and PORT is the TCP port of the VISA server.

Notes: 
(1) You may use VISA <Find Resources> to get the Resource Name for your device. Use "USB?*INSTR{VI_ATTR_MANF_ID==0x1313 && VI_ATTR_MODEL_CODE==0x8080}" as a search string for <Find Resources>.
     �    This parameter returns an instrument handle that is used in all subsequent calls to distinguish between different sessions of this instrument driver.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     �    This parameter specifies whether an identification query is performed during the initialization process.

VI_OFF (0): Skip query.
VI_ON  (1): Do query (default).
     �    This parameter specifies whether the instrument is reset during the initialization process.

VI_OFF (0) - no reset 
VI_ON  (1) - instrument is reset (default)
    	� (   �     Resource Name                     R �� �  �    Instrument Handle                 �����  �    Status                          ����, ��                                         ���� ��                                           f d ( �       ID-Query                           d � �       Reset Device                       2"USB0::0x1313::0x8081::DEVICE-SERIAL-NUMBER::RAW"    	           	           Copyright� 2013 Thorlabs GmbH    +Thorlabs CCS Series VISA Instrument Driver  ! Do Query VI_ON Skip Query VI_OFF  & Reset Device VI_ON Don't Reset VI_OFF    A    This function sets the optical integration time in seconds [s].     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter accepts the optical integration time for the CCS in seconds [s].
          
Valid range:   CCS_SERIES_MIN_INT_TIME (1.0E-5) ...
               CCS_SERIES_MAX_INT_TIME (6.0E+1)

Default value: 1.0E-3.
    `����  �    Status                            �   �  �    Instrument Handle                 U ( ( �  x    Integration Time [s]               	               0.001    �    This function queries the integration time.
      
Note:
The value this function returns is (reverse) calculated from discrete timer counter values of the CCS and may therfore slightly differ from the value set with the function 'Set Interagtion Time'.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     G    This parameter returns the optical integration time in seconds [s].

    �����  �    Status                            j   �  �    Instrument Handle                 � (� �  x    Integration Time [s]               	               	           �    This function triggers the the CCS to take one single scan.
      
Note:
The scan data can be read out with the function 'Get Scan Data'
Use 'Get Device Status' to check the scan status.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     y    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.
    �����  �    Status                            -   �  �    Instrument Handle                  	              	    This function starts the CCS scanning continuously. Any other function except 'Get Scan Data' and 'Get Device Status' will stop the scanning.

Note:
The scan data can be read out with the function 'Get Scan Data' 
Use 'Get Device Status' to check the scan status.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    9����  �    Status                            � 
  �  �    Instrument Handle                  	              *    This function arms the external trigger of the CCS. A following low to high transition at the trigger input of the CCS starts a scan.

Note:
When you issue a read command 'Get Scan Data' before the CCS was triggered you will get a timeout error. Use 'Get Device Status' to check the scan status.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    �����  �    Status                            O 
  �  �    Instrument Handle                  	                  This function arms the CCS for scanning after an external trigger. A following low to high transition at the trigger input of the CCS then starts a scan. The CCS will rearm immediately after the scan data is readout. Any other function except 'Get Scan Data' or 'Get Device Status' will stop the scanning. 

Note:
The scan data can be read out with the function 'Get Scan Data' 


Note:
When you issue a read command 'Get Scan Data' before the CCS was triggered you will get a timeout error. Use 'Get Device Status' to check the scan status.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     p����  �    Status                             � 
  �  �    Instrument Handle                  	               �    This function retrieves the status of the CCS. You can use this function to detect if an external trigger has already occurred.

Note:
The values anove are defined in the drivers header file.


     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.        This parameter returns the instruments status (4 bytes).
You can mask out the relevant status bits.

// CCS waits for new scan to execute 
CCS_SERIES_STATUS_SCAN_IDLE            0x0002

// scan in progress  
CCS_SERIES_STATUS_SCAN_TRIGGERED       0x0004

// scan starting  
CCS_SERIES_STATUS_SCAN_START_TRANS     0x0008
  
// scan is done, waiting for data transfer to PC
CCS_SERIES_STATUS_SCAN_TRANSFER        0x0010

// same as IDLE except that external trigger is armed    
CCS_SERIES_STATUS_WAIT_FOR_EXT_TRIG    0x0080    "�����  �    Status                            #  
  �  �    Instrument Handle                 #� <  �  �    Device Status                      	               	            �    This function reads out the processed scan data.

Note:
When the raw scan data is overexposed, so that a proper data processing is not possible, the function returns

VI_ERROR_SCAN_DATA_INVALID

and all data points are set to zero (0.0).
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter returns the processed scan data.

Note:
The array must contain at least CCS_SERIES_NUM_PIXELS (3648) elements (ViReal64[CCS_SERIES_NUM_PIXELS]).     'g����  �    Status                            '�   �  �    Instrument Handle                 (\ (� �  x    Data                               	               	            �    This function gets data of one scan. 

Note:
In external triggered mode, when you issue this command before the CCS was triggered you will get a timeout error.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter returns the unprocessed scanned data. The values represent the AD converted values. 


Note:
The array must contain at least CCS_SERIES_NUM_RAW_PIXELS (3694) elements (ViUInt16[CCS_SERIES_NUM_RAW_PIXELS]). 
    *k����  �    Status                            *� 
  �  �    Instrument Handle                 +` <, �  �    Scan Data Array                    	               	           �    This function stores data for user-defined pixel-wavelength correlation to the instrument's nonvolatile memory.

The given data pair arrays are used to interpolate the pixel-wavelength correlation array returned by the CCSseries_getWavelengthData function. 

Note: In case the interpolated pixel-wavelength correlation contains negative values, or the values are not strictly increasing the function returns with error VI_ERROR_INV_USER_DATA.
    (    This parameter accepts the pixel values of the pixel/wavelength data pairs. The valid range for pixel values is from 0 up to CCS_SERIES_NUM_PIXEL - 1 (3647).


Note:
The array must contain at least CCS_SERIES_MIN_NUM_USR_ADJ (4) elements and at most CCS_SERIES_MAX_NUM_USR_ADJ (10) elements. 

     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.        This parameter accepts the wavelength values of the pixel/wavelength data pairs in nm. The wavelength value has to be positive.


Note:
The array must contain at least CCS_SERIES_MIN_NUM_USR_ADJ (4) elements and at most CCS_SERIES_MAX_NUM_USR_ADJ (10) elements.
     �    This parameter accepts the number of elements in the Pixel Data Array and the Wavelength Data Array. 

Note:
This value has to be at least CCS_SERIES_MIN_NUM_USR_ADJ (4) and at most CCS_SERIES_MAX_NUM_USR_ADJ (10). 
    .� %  �  �    Pixel Data Array                  /� 
  �  �    Instrument Handle                 0x����  �    Status                            0� % �  �    Wavelength Data Array             1� p  �  �    Buffer Length                      	                	           	            0   K    This function returns data for the pixel-wavelength correlation.
The maximum and the minimum wavelength are additionally provided in two separate return values.

Note:
If you do not need either of these values you may pass NULL.


The value returned in Wavelength_Data_Array[0] is the wavelength at pixel 1, this is also the minimum wavelength, the value returned in Wavelength_Data_Array[1] is the wavelength at pixel 2 and so on until Wavelength_Data_Array[CCS_SERIES_NUM_PIXELS-1] which provides the wavelength at pixel CCS_SERIES_NUM_PIXELS (3648). This is the maximum wavelength.
     �    This parameter returns the wavelength data.


Note:
The array must contain at least CCS_SERIES_NUM_PIXELS (3648) elements (ViReal64[CCS_SERIES_NUM_PIXELS]). If you do not need the array you may pass NULL for this parameter.
     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     �    This parameter returns the minimum wavelength in nanometers (nm). It is the same value as returned in Wavelength Data Array position 0.


Note:
You mas pass NULL for this parameter.. 
     �    This parameter returns the maximum wavelength in nanometers (nm). It is the same value as returned in Wavelength Data Array position CCS_SERIES_NUM_PIXELS - 1 (3647).


Note:
You mas pass NULL for this parameter.. 
    |    This parameter specifies which calibration data set has to be used for generating the wavelength data array.

Values:
CCS_SERIES_CAL_DATA_SET_FACTORY (0) - Use factory adjustment data to generate the wavelength data array.

CCS_SERIES_CAL_DATA_SET_USER (1) - Use user-defined adjustment data to generate the wavelength data array. (see also function CCSseries_setWavelengthData)    6h <, �  �    Wavelength Data Array             7R 
  �  �    Instrument Handle                 7�����  �    Status                            8G �� �  �    Minimum Wavelength                9	 �� �  �    Maximum Wavelength                9� = � �       Data Set                           	                	                  400           400               3Factory Calibration Data 0 User Calibration Data 1   �    This function returns the user-defined pixel-wavelength correlation supporting points. These given data pair arrays are used by the driver to interpolate the pixel-wavelength correlation array returned by the CCSseries_getWavelengthData function. 

Note:
If you do not need either of these values you may pass NULL.
The function returns with error VI_ERROR_CCS_SERIES_NO_USER_DATA if no user calibration data is present in the instrument's nonvolatile memory.     �    This parameter will receive the pixel values of the user-defined pixel/wavelength data pairs. 


Note:
The array must contain CCS_SERIES_MAX_NUM_USR_ADJ (10) elements. 
You may pass NULL.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     �    This parameter will receive the wavelength values of the user-defined pixel/wavelength data pairs. 


Note:
The array must contain CCS_SERIES_MAX_NUM_USR_ADJ (10) elements. 
You may pass NULL.     �    This parameter receives the number of elements in the Pixel Data Array and the Wavelength Data Array. 

Note:
You may pass NULL. In case no user calibration data is present the parameter will be set to 0.    >� %  �  �    Pixel Data Array                  ?� 
  �  �    Instrument Handle                 @B����  �    Status                            @� % �  �    Wavelength Data Array             A� py �  �    Buffer Length                      	                	           	            	            �    This function stores data for user-defined pixel-amplitude correction factors to the instrument's nonvolatile memory.

The factor array can be used to correct the amplitudes of each pixel returned by the CCSseries_getScanData function. 
     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     y    This parameter accepts the amplitude correction factor array. 

Note:
The array must be at least of Buffer Length size
    �    This parameter indicates the length of the amplitude correction factor array. Buffer Length values from given parameter Amplitude_Correction_Factors[] will replace the data stored in the user amplitude correction factor array.


Note:
This value has to be in the range of 1 to CCS_SERIES_NUM_PIXELS (3648). The sum of this parameter and the parameter Buffer Start must not exceed CCS_SERIES_NUM_PIXELS (3648).
    �    This parameter is the start index for the amplitude correction factor array. From this point on the data given in the parameter Amplitude_Correction_Factors[] will replace the data stored in the user amplitude correction factor array.


Note:
This value has to be in the range of
0 to CCS_SERIES_NUM_PIXELS  - 1 (3647).
The sum of this parameter and the parameter Buffer_Length must not exceed CCS_SERIES_NUM_PIXELS (3648).
        This parameter indicates the mode of setting the amplitude correction factor array.

If mode is set to ACOR_APPLY_TO_MEAS (1) the data will be applied for the current measurements but will not go into the device's non volatile memory.

If mode is set to ACOR_APPLY_TO_MEAS_NVMEM (2) the data will be  applied to the current measurements and will be additionally stored in the device's non volatile memory.


Note:
If mode is set to any other value the function will return error VI_ERROR_INV_PARAMETER (0xBFFF0078).
    D� 
  �  �    Instrument Handle                 E|���  �    Status                            E� (" �  �    Amplitude Correction Factors      F n 
 �  �    Buffer Length                     G� ( 
 �  �    Buffer Start                      IW n| �  �    Mode                                   	           	            0    0    0   �    This function returns data for the user-defined amplitude correction factors.  

Note:
The value returned in Amplitude_Correction_Factors[0] is the amplitude correction factor at pixel 1, the value returned in Amplitude_Correction_Factors[1] is the amplitude correction factor at pixel 2 and so on until Amplitude_Correction_Factors[CCS_SERIES_NUM_PIXELS-1] which provides the amplitude correction factor at pixel CCS_SERIES_NUM_PIXELS (3648). 
     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     y    This parameter accepts the amplitude correction factor array. 

Note:
The array must be at least of Buffer Length size
    �    This parameter is the start index for the amplitude correction factor array. From this point on the data stored in the user amplitude correction factor array will be stored in the parameter Amplitude_Correction_Factors[].


Note:
This value has to be in the range of
0 to CCS_SERIES_NUM_PIXELS - 1 (3647).
The sum of this parameter and the parameter Buffer_Length must not exceed CCS_SERIES_NUM_PIXELS (3648).
    �    This parameter indicates the length of the amplitude correction factor array. Buffer length values from given parameter Amplitude_Correction_Factors[] will replace the data stored in the user amplitude correction factor array.


Note:
This value has to be in the range of 1 to CCS_SERIES_NUM_PIXELS (3648). The sum of this parameter and the parameter Buffer Start must not exceed CCS_SERIES_NUM_PIXELS (3648).
    �    This parameter indicates the mode of getting the amplitude correction factor array.

If mode is set to ACOR_FROM_CURRENT (1) the data will be retrieved from the currently used amplitude correction factors.

If mode is set to ACOR_FROM_NVMEM (2) the data will be read out from the device's non volatile memory and additionally applied to the current measurements.


Note:
If mode is set to any other value the function will return error VI_ERROR_INV_PARAMETER (0xBFFF0078).
    N� 
  �  �    Instrument Handle                 O|���  �    Status                            O� ( �  �    Amplitude Correction Factors      P ( 
 �  �    Buffer Start                      Q� n 
 �  �    Buffer Length                     SS n| �  �    Mode                                   	           	            0    0    0    >    This function returns the device identification information.     �    This parameter returns the manufacturer name.

Notes:
(1) The array must contain at least 256 elements ViChar[256].
(2) You may pass VI_NULL if you do not need this value.
     �    This parameter returns the device name.

Notes:
(1) The array must contain at least 256 elements ViChar[256].
(2) You may pass VI_NULL if you do not need this value.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter returns the device serial number.

Notes:
(1) The array must contain at least 256 elements ViChar[256].
(2) You may pass VI_NULL if you do not need this value.
     �    This parameter returns the device firmware revision.

Notes:
(1) The array must contain at least 256 elements ViChar[256].
(2) You may pass VI_NULL if you do not need this value.
     �    This parameter returns the driver revision.

Notes:
(1) The array must contain at least 256 elements ViChar[256].
(2) You may pass VI_NULL if you do not need this value.
    V� ( ( �  �    Manufacturer Name                 W� (, �  �    Device Name                       XK����  �    Status                            X�   �  �    Instrument Handle                 Y@ n ( �  �    Serial Number                     Y� n, �  �    Firmware Revision                 Z� � ( �  �    Instrument Driver Revision         	            	            	               	            	            	            ^    This function returns the revision numbers of the instrument driver and the device firmware.        This parameter returns the instrument driver revision.

Notes:
(1) The 32 bits of revision are divided into 12 bits for major revision (MSB), 12 bits for minor revision and 8 bits for subminor revision (LSB). You can use the macros provided in the header file to extract major, minor, subminor from the revision provided here.

RevMajor    = CCS_SERIES_EXTRACT_MAJOR(revision);
RevMinor    = CCS_SERIES_EXTRACT_MINOR(revision);
RevSubminor = CCS_SERIES_EXTRACT_SUBMINOR(revision);

(2) You may pass VI_NULL if you do not need this value.
        This parameter returns the instrument firmware revision.

Notes:
(1) The 32 bits of revision are divided into 12 bits for major revision (MSB), 12 bits for minor revision and 8 bits for subminor revision (LSB). You can use the macros provided in the header file to extract major, minor, subminor from the revision provided here.

RevMajor    = CCS_SERIES_EXTRACT_MAJOR(revision);
RevMinor    = CCS_SERIES_EXTRACT_MINOR(revision);
RevSubminor = CCS_SERIES_EXTRACT_SUBMINOR(revision);

(2) You may pass VI_NULL if you do not need this value.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     �    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session. You may pass VI_NULL.

Note: If you pass VI_NULL an empty string will be returned for the firmware revision parameter.    ]� ( ( � �    Instrument Driver Revision        _� n ( � �    Firmware Revision                 a�����  �    Status                            bN   �  �    Instrument Handle                  	            	            	           VI_NULL    "    This function resets the device.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    dr����  �    Status                            d�   �  �    Instrument Handle                  	               N    This function runs the device self test routine and returns the test result.     �    This parameter contains the value returned from the device self test routine. A returned zero value indicates a successful run, a value other than zero indicates failure.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter returns the instrument's self test message.

Notes: The array must contain at least 256 elements ViChar[256].
You may pass VI_NULL if you do not need this value.
    f7 ( ( �  x    Self Test Result                  f�����  �    Status                            g`   �  �    Instrument Handle                 g� ( � � h    Self Test Message                  	            	               	           C    This function queries the instrument's error queue manually. 
Use this function to query the instrument's error queue if the driver's error query mode is set to manual query. 

Note: The returned values are stored in the drivers error store. You may use <Error Message> to get a descriptive text at a later point of time.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     p    This parameter returns the instrument error number.

Note: You may pass VI_NULL if you don't need this value.
     �    This parameter returns the instrument error message.

Notes: The array must contain at least 256 elements ViChar[256].
You may pass VI_NULL if you do not need this value.
    j�����  �    Status                            kW   �  �    Instrument Handle                 k� ( ( �  x    Error Number                      lO ( � � h    Error Message                      	               	            	           �    This function takes the error code returned by the instrument driver functions interprets it and returns it as an user readable string. 

Status/error codes and description:

--- Instrument Driver Errors and Warnings ---
Status      Description
-------------------------------------------------
         0  No error (the call was successful).
0x3FFF0085  Unknown Status Code     - VI_WARN_UNKNOWN_STATUS
0x3FFC0901  WARNING: Value overflow - VI_INSTR_WARN_OVERFLOW
0x3FFC0902  WARNING: Value underrun - VI_INSTR_WARN_UNDERRUN
0x3FFC0903  WARNING: Value is NaN   - VI_INSTR_WARN_NAN
0xBFFC0001  Parameter 1 out of range. 
0xBFFC0002  Parameter 2 out of range.
0xBFFC0003  Parameter 3 out of range.
0xBFFC0004  Parameter 4 out of range.
0xBFFC0005  Parameter 5 out of range.
0xBFFC0006  Parameter 6 out of range.
0xBFFC0007  Parameter 7 out of range.
0xBFFC0008  Parameter 8 out of range.
0xBFFC0012  Error Interpreting instrument response.

--- Instrument Errors --- 
Range: 0xBFFC0700 .. 0xBFFC0CFF.
Calculation: Device error code + 0xBFFC0900.
Please see your device documentation for details.

--- VISA Errors ---
Please see your VISA documentation for details.
     v    This parameter accepts the error codes returned from the instrument driver functions.

Default Value: 0 - VI_SUCCESS     �    This parameter returns the interpreted code as an user readable message string.

Notes:
(1) The array must contain at least 512 elements ViChar[512].
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     �    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session. You may pass VI_NULL.

Note: If VI_NULL is passed to this parameter it is not possible to get device specific messages.    r� ( ( �  x    Status Code                       s ( � � h    Description                       s�����  �    Status                            t)   �  �    Instrument Handle                  0    	            	               c    This function transfers a user definable text and saves it in the nonvolatile memory of the CCS.
     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.        This parameter specifies a user definable string.

Note: 
The string will be truncated to CCS_SERIES_MAX_USER_NAME_SIZE-1 (31) characters. The number of characters stored in the CCS is always CCS_SERIES_MAX_USER_NAME_SIZE (32), the last character stored is always the NUL character.
    v�����  �    Status                            v� 
  �  �    Instrument Handle                 wv <  �     User Text                          	               	"My CCS"    Y    This function receives a user defined text stored in the nonvolatile memory of the CCS.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.     �    This parameter returns a user defined string.

Note: 
The buffer must contain at least CCS_SERIES_MAX_USER_NAME_SIZE (32) elements (ViChar[CCS_SERIES_MAX_USER_NAME_SIZE]).
    y�����  �    Status                            z, 
  �  �    Instrument Handle                 z� <  �     User Text                          	               	            >    Sets a specified attribute for the given instrument session.     r    This value shows the status code returned by the function call.

For Status Codes see function <Error Message>.
     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    B    Specifies the attribute whose value you want to set.

Attributes:

CCS_SERIES_ATTR_USER_DATA
Description:  This attribute value is the data used privately by the application for a particular session. This data is not used by the instrument driver for any purposes. It is provided to the application for its own use.
         4    The value to which to set the specified attribute.    |c����  �    Status                            |�   �  �    Instrument Handle                 }] ( ( �,    Attribute                         ~� (� �  x    Value                              	                          $User Data CCS_SERIES_ATTR_USER_DATA    0    A    Queries a specified attribute for the given instrument session.     r    This value shows the status code returned by the function call.

For Status Codes see function <Error Message>.
     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    �    Specifies the attribute whose value you want to query.

Attributes:

CCS_SERIES_ATTR_USER_DATA
Description:  This attribute value is the data used privately by the application for a particular session. This data is not used by the instrument driver for any purposes. It is provided to the application for its own use.
    
CCS_SERIES_ATTR_CAL_MODE
Description:  This attribute value returns either CCS_SERIES_CAL_MODE_USER (0) or CCS_SERIES_CAL_MODE_THORLABS (1). This shows whether the amplitude correction data set by function CCSseries_setAmplitudeData() or read by function CCSseries_getAmplitudeData() is data provided by the user or provided by THORLABS.     '    The value of the specified attribute.    �H����  �    Status                            ��   �  �    Instrument Handle                 �B ( ( �,    Attribute                         �� (� �  x    Value                              	                          NUser Data CCS_SERIES_ATTR_USER_DATA Calibration Mode CCS_SERIES_ATTR_CAL_MODE    	            r    This function closes the instrument driver session.

Note: The instrument must be reinitialized to use it again.     m    This is the error code returned by the function call. For error codes and descriptions see <Error Message>.     x    This parameter accepts the instrument handle returned by <Initialize> to select the desired instrument driver session.    ������  �    Status                            �K   �  �    Instrument Handle                  	            ����         �  �             K.        init                                                                            _VI_FUNC                                                ����           6             K.        setIntegrationTime                                                              _VI_FUNC                                                ����         �  9             K.        getIntegrationTime                                                              _VI_FUNC                                                ����         �  �             K.        startScan                                                                       _VI_FUNC                                                ����         (  .             K.        startScanCont                                                                   _VI_FUNC                                                ����         �  �             K.        startScanExtTrg                                                                 _VI_FUNC                                                ����         I  !e             K.        startScanContExtTrg                                                             _VI_FUNC                                                ����         !�  %�             K.        getDeviceStatus                                                                 _VI_FUNC                                                ����         &o  )             K.        getScanData                                                                     _VI_FUNC                                                ����         )�  ,H             K.        getRawScanData                                                                  _VI_FUNC                                                ����         -  2�             K.        setWavelengthData                                                               _VI_FUNC                                                ����         4  ;n             K.        getWavelengthData                                                               _VI_FUNC                                                ����         =(  BW             K.        getUserCalibrationPoints                                                        _VI_FUNC                                                ����         C�  Ke             K.        setAmplitudeData                                                                _VI_FUNC                                                ����         L�  U6             K.        getAmplitudeData                                                                _VI_FUNC                                                ����         V�  [j             K.        identificationQuery                                                             _VI_FUNC                                                ����         ])  cE             K.        revisionQuery                                                                   _VI_FUNC                                                ����         dH  eg             K.        reset                                                                           _VI_FUNC                                                ����         e�  h�             K.        selfTest                                                                        _VI_FUNC                                                ����         i�  m             K.        errorQuery                                                                      _VI_FUNC                                                ����         n   u!             K.        errorMessage                                                                    _VI_FUNC                                                ����         v  x�             K.        setUserText                                                                     _VI_FUNC                                                ����         yV  {b             K.        getUserText                                                                     _VI_FUNC                                                ����         |  ~�             K.        setAttribute                                                                    _VI_FUNC                                                ����         �  �             K.        getAttribute                                                                    _VI_FUNC                                                ����         �\  ��             K.        close                                                                           _VI_FUNC                                                      �                                                                                     �Initialize                                                                          +Configuration Functions                                                              �Set Integration Time                                                                 �Get Integration Time                                                                �Action/Status Functions                                                              �Start Scan                                                                           �Start Scan Continuous                                                                �Start Ext Triggered Scan                                                             �Start Scan Continuous Ext. Trigger                                                   �Get Device Status                                                                 ����Data Functions                                                                       �Get Scan Data                                                                        �Get Raw Scan Data                                                                    �Set Wavelength Data                                                                  �Get Wavelength Data                                                                  �Get User Calibration Points                                                          �Set Amplitude Data                                                                   �Get Amplitude Data                                                                  .Utility Functions                                                                    �Identification Query                                                                 �Revision Query                                                                       �Reset                                                                                �Self-Test                                                                            �Error Query                                                                          �Error Message                                                                        �Set User Text                                                                        �Get User Text                                                                        �Set Attribute                                                                        �Get Attribute                                                                        �Close                                                                           