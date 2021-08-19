// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 9055 "ABS Container Helper"
{
    Access = Internal;

    var
        Container: Record "ABS Container";
        OperationPayload: Codeunit "ABS Operation Payload";
        StorageAccountName: Text;
        ContainerName: Text;

    procedure SetContainer(var NewContainer: Record "ABS Container")
    begin
        Container := NewContainer;
    end;

    procedure SetBaseInfos(NewOperationPayload: Codeunit "ABS Operation Payload")
    begin
        StorageAccountName := OperationPayload.GetStorageAccountName();
        ContainerName := OperationPayload.GetContainerName();
        OperationPayload := NewOperationPayload;
    end;

    procedure AddNewEntryFromNode(var Node: XmlNode; XPathName: Text)
    var
        HelperLibrary: Codeunit "ABS Helper Library";
        NameFromXml: Text;
        OuterXml: Text;
        ChildNodes: XmlNodeList;
        PropertiesNode: XmlNode;
    begin
        NameFromXml := HelperLibrary.GetValueFromNode(Node, XPathName);
        Node.WriteTo(OuterXml);
        Node.SelectSingleNode('.//Properties', PropertiesNode);
        ChildNodes := PropertiesNode.AsXmlElement().GetChildNodes();
        if ChildNodes.Count = 0 then
            AddNewEntry(NameFromXml, OuterXml)
        else
            AddNewEntry(NameFromXml, OuterXml, ChildNodes);
    end;

    procedure AddNewEntry(NameFromXml: Text; OuterXml: Text)
    var
        ChildNodes: XmlNodeList;
    begin
        AddNewEntry(NameFromXml, OuterXml, ChildNodes);
    end;

    procedure AddNewEntry(NameFromXml: Text; OuterXml: Text; ChildNodes: XmlNodeList)
    var
        Outstr: OutStream;
    begin
        Container.Init();
        Container.Name := CopyStr(NameFromXml, 1, 250);
        SetPropertyFields(ChildNodes);
        Container."XML Value".CreateOutStream(Outstr);
        Outstr.Write(OuterXml);
        //Rec.URI := HelperLibrary.ConstructUrl(StorageAccountName, OperationPayload, Operation::ListContainerContents, ContainerName, NameFromXml); // TODO: Should this be removed?
        Container.Insert(true);
    end;

    local procedure SetPropertyFields(ChildNodes: XmlNodeList)
    var
        FormatHelper: Codeunit "ABS Format Helper";
        HelperLibrary: Codeunit "ABS Helper Library";
        RecRef: RecordRef;
        FldRef: FieldRef;
        ChildNode: XmlNode;
        PropertyName: Text;
        PropertyValue: Text;
        FldNo: Integer;
    begin
        foreach ChildNode in ChildNodes do begin
            PropertyName := ChildNode.AsXmlElement().Name;
            PropertyValue := ChildNode.AsXmlElement().InnerText;
            if PropertyValue <> '' then begin
                RecRef.GetTable(Container);
                if HelperLibrary.GetFieldByName(Database::"ABS Container", PropertyName, FldNo) then begin
                    FldRef := RecRef.Field(FldNo);
                    case FldRef.Type of
                        FldRef.Type::DateTime:
                            FldRef.Value := FormatHelper.ConvertToDateTime(PropertyValue);
                        FldRef.Type::Integer:
                            FldRef.Value := FormatHelper.ConvertToInteger(PropertyValue);
                        FldRef.Type::Boolean:
                            FldRef.Value := FormatHelper.ConvertToBoolean(PropertyValue);
                        else
                            FldRef.Value := PropertyValue;
                    end;
                end;
            end;
            RecRef.SetTable(Container);
        end;
    end;
}