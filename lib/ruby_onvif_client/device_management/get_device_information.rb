require_relative '../action'

module ONVIF
    module DeviceManagementAction
        class GetDeviceInformation < Action
            def run cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetDeviceInformation)
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        puts("info=====>>>>", xml_doc.to_s)
                        info = {
                            mf: value(xml_doc, '//tds:Manufacturer'),
                            model: value(xml_doc, '//tds:Model'),
                            firmware_version: value(xml_doc, '//tds:FirmwareVersion'),
                            serial_number: value(xml_doc, '//tds:SerialNumber'),
                            hardware_id: value(xml_doc, '//tds:HardwareId'),
                            # Body: value(xml_doc, '//env:Body'),
                            all: value(xml_doc, xml_doc.to_s)
                        }
                        callback cb, success, info
                    else
                        callback cb, success, result
                    end
                end
            end
        end
    end
end

