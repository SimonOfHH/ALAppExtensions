// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

// See: https://docs.microsoft.com/en-us/rest/api/storageservices/blob-service-rest-api
codeunit 9041 "Blob Services API Impl."
{
    Access = Internal;

    var
        #region State
        OperationPayload: Codeunit "Blob API Operation Payload";
        #endregion

        BlobAPIHttpContentHelper: Codeunit "Blob API HttpContent Helper";
        BlobAPIWebRequestHelper: Codeunit "Blob API Web Request Helper";
        BlobAPIValueHelper: Codeunit "Blob API Value Helper";

        #region Labels
        ListContainercOperationNotSuccessfulErr: Label 'Could not list container.';
        ListBlobsContainercOperationNotSuccessfulErr: Label 'Could not list blobs for container %1.', Comment = '%1 = Container Name';
        CreateContainerOperationNotSuccessfulErr: Label 'Could not create container %1.', Comment = '%1 = Container Name';
        DeleteContainerOperationNotSuccessfulErr: Label 'Could not delete container %1.', Comment = '%1 = Container Name';
        UploadBlobOperationNotSuccessfulErr: Label 'Could not upload %1 to %2', Comment = '%1 = Blob Name; %2 = Container Name';
        DeleteBlobOperationNotSuccessfulErr: Label 'Could not %3 Blob %1 in container %2.', Comment = '%1 = Blob Name; %2 = Container Name, %3 = Delete/Undelete';
        CopyOperationNotSuccessfulErr: Label 'Could not copy %1 to %2.', Comment = '%1 = Source, %2 = Desctination';
        AppendBlockFromUrlOperationNotSuccessfulErr: Label 'Could not append block from URL %1 on %2.', Comment = '%1 = Source URI; %2 = Blob';
        TagsOperationNotSuccessfulErr: Label 'Could not %1%2 Tags.', Comment = '%1 = Get/Set, %2 = Service/Blob, ';
        FindBlobsByTagsOperationNotSuccessfulErr: Label 'Could not find Blobs by Tags.';
        PutBlockOperationNotSuccessfulErr: Label 'Could not put block on %1.', Comment = '%1 = Blob';
        GetBlobOperationNotSuccessfulErr: Label 'Could not get Blob %1.', Comment = '%1 = Blob';
        BlockListOperationNotSuccessfulErr: Label 'Could not %2 block list on %1.', Comment = '%1 = Blob; %2 = Get/Set';
        PutBlockFromUrlOperationNotSuccessfulErr: Label 'Could not put block from URL %1 on %2.', Comment = '%1 = Source URI; %2 = Blob';
        ExpiryOperationNotSuccessfulErr: Label 'Could not set expiration on %1.', Comment = '%1 = Blob';
    #endregion

    procedure Initialize(StorageAccountName: Text; ContainerName: Text; BlobName: Text; Authorization: Interface "Storage Service Authorization"; ApiVersion: Enum "Storage Service API Version")
    begin
        OperationPayload.Initialize(StorageAccountName, ContainerName, BlobName, Authorization, ApiVersion);
    end;

    #region Account operations
    procedure ListContainers(var Container: Record "Container"): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        HelperLibrary: Codeunit "Blob API Helper Library";
        Operation: Enum "Blob Service API Operation";
        ResponseText: Text;
        NodeList: XmlNodeList;
    begin
        OperationPayload.SetOperation(Operation::ListContainers);

        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, ResponseText, ListContainercOperationNotSuccessfulErr);

        NodeList := HelperLibrary.CreateContainerNodeListFromResponse(ResponseText);
        Container.SetBaseInfos(OperationPayload);
        HelperLibrary.ContainerNodeListTotempRecord(NodeList, Container);
        exit(OperationResponse);
    end;
    #endregion

    #region Container operations
    procedure CreateContainer(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::CreateContainer);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, StrSubstNo(CreateContainerOperationNotSuccessfulErr, OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure DeleteContainer(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::DeleteContainer);
        OperationResponse := BlobAPIWebRequestHelper.DeleteOperation(OperationPayload, StrSubstNo(DeleteContainerOperationNotSuccessfulErr, OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure ListBlobs(var ContainerContent: Record "Container Content"): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        HelperLibrary: Codeunit "Blob API Helper Library";
        Operation: Enum "Blob Service API Operation";
        ResponseText: Text;
        NodeList: XmlNodeList;
    begin
        OperationPayload.SetOperation(Operation::ListBlobs);

        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, ResponseText, StrSubstNo(ListBlobsContainercOperationNotSuccessfulErr, OperationPayload.GetContainerName()));

        NodeList := HelperLibrary.CreateBlobNodeListFromResponse(ResponseText);
        ContainerContent.SetBaseInfos(OperationPayload);
        HelperLibrary.BlobNodeListToTempRecord(NodeList, ContainerContent);
        exit(OperationResponse);
    end;
    #endregion

    #region Blob operation
    procedure PutBlobBlockBlobUI(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Filename: Text;
        SourceStream: InStream;
    begin
        if UploadIntoStream('*.*', SourceStream) then
            OperationResponse := PutBlobBlockBlobStream(Filename, SourceStream);
        exit(OperationResponse);
    end;

    procedure PutBlobBlockBlobStream(BlobName: Text; var SourceStream: InStream): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        SourceContent: Variant;
    begin
        SourceContent := SourceStream;
        OperationPayload.SetBlobName(BlobName);
        OperationResponse := PutBlobBlockBlob(SourceContent);
        exit(OperationResponse);
    end;

    procedure PutBlobBlockBlobText(BlobName: Text; SourceText: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        SourceContent: Variant;
    begin
        SourceContent := SourceText;
        OperationPayload.SetBlobName(BlobName);
        OperationResponse := PutBlobBlockBlob(SourceContent);
        exit(OperationResponse);
    end;

    local procedure PutBlobBlockBlob(var SourceContent: Variant): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
        SourceStream: InStream;
        SourceText: Text;
    begin
        OperationPayload.SetOperation(Operation::PutBlob);

        case true of
            SourceContent.IsInStream():
                begin
                    SourceStream := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceStream);
                end;
            SourceContent.IsText():
                begin
                    SourceText := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceText);
                end;
        end;

        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(UploadBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure PutBlobPageBlob(ContentType: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::PutBlob);
        BlobAPIHttpContentHelper.AddBlobPutPageBlobContentHeaders(OperationPayload, 0, ContentType);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, StrSubstNo(UploadBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure PutBlobAppendBlob(ContentType: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::PutBlob);
        BlobAPIHttpContentHelper.AddBlobPutAppendBlobContentHeaders(OperationPayload, ContentType);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, StrSubstNo(UploadBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure AppendBlockText(ContentAsText: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
    begin
        OperationResponse := AppendBlockText(ContentAsText, 'text/plain; charset=UTF-8');
        exit(OperationResponse);
    end;

    procedure AppendBlockText(ContentAsText: Text; ContentType: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
    begin
        OperationResponse := AppendBlock(ContentType, ContentAsText);
        exit(OperationResponse);
    end;

    procedure AppendBlockStream(ContentAsStream: InStream): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
    begin
        OperationResponse := AppendBlockStream(ContentAsStream, 'application/octet-stream');
        exit(OperationResponse);
    end;

    procedure AppendBlockStream(ContentAsStream: InStream; ContentType: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
    begin
        OperationResponse := AppendBlock(ContentType, ContentAsStream);
        exit(OperationResponse);
    end;

    procedure AppendBlock(ContentType: Text; SourceContent: Variant): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
        SourceStream: InStream;
        SourceText: Text;
    begin
        OperationPayload.SetOperation(Operation::AppendBlock);
        case true of
            SourceContent.IsInStream():
                begin
                    SourceStream := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceStream);
                end;
            SourceContent.IsText():
                begin
                    SourceText := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceText);
                end;
        end;

        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(UploadBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName()));
        exit(OperationResponse);
    end;

    procedure AppendBlockFromURL(SourceUri: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
    begin
        OperationPayload.SetOperation(Operation::AppendBlockFromURL);
        OperationPayload.AddHeader('Content-Length', '0');
        BlobAPIValueHelper.SetCopySourceNameHeader(OperationPayload, SourceUri);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(AppendBlockFromUrlOperationNotSuccessfulErr, SourceUri, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure GetBlobAsFile(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        BlobName: Text;
        TargetStream: InStream;
    begin
        OperationResponse := GetBlobAsStream(TargetStream);
        BlobName := OperationPayload.GetBlobName();
        DownloadFromStream(TargetStream, '', '', '', BlobName);
        exit(OperationResponse);
    end;

    procedure GetBlobAsStream(var TargetStream: InStream): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::GetBlob);
        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsStream(OperationPayload, TargetStream, StrSubstNo(GetBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure GetBlobAsText(var TargetText: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::GetBlob);
        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, TargetText, StrSubstNo(GetBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure SetBlobExpiryRelativeToCreation(ExpiryTime: Integer): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        ExpiryOption: Enum "Blob Expiry Option";
    begin
        OperationResponse := SetBlobExpiry(ExpiryOption::RelativeToCreation, ExpiryTime, StrSubstNo(ExpiryOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure SetBlobExpiryRelativeToNow(ExpiryTime: Integer): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        ExpiryOption: Enum "Blob Expiry Option";
    begin
        OperationResponse := SetBlobExpiry(ExpiryOption::RelativeToNow, ExpiryTime, StrSubstNo(ExpiryOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure SetBlobExpiryAbsolute(ExpiryTime: DateTime): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        ExpiryOption: Enum "Blob Expiry Option";
    begin
        OperationResponse := SetBlobExpiry(ExpiryOption::Absolute, ExpiryTime, StrSubstNo(ExpiryOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure SetBlobExpiryNever(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        ExpiryOption: Enum "Blob Expiry Option";
    begin
        OperationResponse := SetBlobExpiry(ExpiryOption::NeverExpire, '', StrSubstNo(ExpiryOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure SetBlobExpiry(ExpiryOption: Enum "Blob Expiry Option"; ExpiryTime: Variant; OperationNotSuccessfulErr: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        DateTimeValue: DateTime;
        IntegerValue: Integer;
        SpecifyMilisecondsErr: Label 'You need to specify an Integer Value (number of miliseconds) for option %1', Comment = '%1 = Expiry Option';
        SpecifyDateTimeErr: Label 'You need to specify an DateTime Value for option %1', Comment = '%1 = Expiry Option';
    begin
        OperationPayload.SetOperation(Operation::SetBlobExpiry);
        BlobAPIValueHelper.SetBlobExpiryOptionHeader(OperationPayload, ExpiryOption);
        case ExpiryOption of
            ExpiryOption::RelativeToCreation, ExpiryOption::RelativeToNow:
                if not ExpiryTime.IsInteger() then
                    Error(SpecifyMilisecondsErr, ExpiryOption);
            ExpiryOption::Absolute:
                if not ExpiryTime.IsDateTime() then
                    Error(SpecifyDateTimeErr, ExpiryOption);
        end;
        if not (ExpiryOption in [ExpiryOption::NeverExpire]) then
            case true of
                ExpiryTime.IsInteger():
                    begin
                        IntegerValue := ExpiryTime;
                        BlobAPIValueHelper.SetBlobExpiryTimeHeader(OperationPayload, IntegerValue);
                    end;
                ExpiryTime.IsDateTime():
                    begin
                        DateTimeValue := ExpiryTime;
                        BlobAPIValueHelper.SetBlobExpiryTimeHeader(OperationPayload, DateTimeValue);
                    end;
            end;
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, OperationNotSuccessfulErr);
        exit(OperationResponse);
    end;

    procedure GetBlobTags(var BlobTags: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
        Operation: Enum "Blob Service API Operation";
        ResponseText: Text;
    begin
        OperationPayload.SetOperation(Operation::GetBlobTags);
        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, ResponseText, StrSubstNo(TagsOperationNotSuccessfulErr, 'get', 'Blob'));
        BlobTags := FormatHelper.TextToXmlDocument(ResponseText);
        exit(OperationResponse);
    end;

    procedure SetBlobTags(Tags: Dictionary of [Text, Text]): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
        Document: XmlDocument;
    begin
        Document := FormatHelper.TagsDictionaryToXmlDocument(Tags);
        OperationResponse := SetBlobTags(Document);
        exit(OperationResponse);
    end;

    procedure SetBlobTags(Tags: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Content: HttpContent;
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::SetBlobTags);
        BlobAPIHttpContentHelper.AddTagsContent(Content, OperationPayload, Tags);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(TagsOperationNotSuccessfulErr, 'set', 'Blob'));
        exit(OperationResponse);
    end;

    procedure FindBlobsByTags(SearchTags: Dictionary of [Text, Text]; var FoundBlobs: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
    begin
        OperationResponse := FindBlobsByTags(FormatHelper.TagsDictionaryToSearchExpression(SearchTags), FoundBlobs);
        exit(OperationResponse);
    end;

    procedure FindBlobsByTags(SearchExpression: Text; var FoundBlobs: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
        Operation: Enum "Blob Service API Operation";
        ResponseText: Text;
    begin
        OperationPayload.SetOperation(Operation::FindBlobByTags);
        OperationPayload.AddOptionalUriParameter('where', SearchExpression);
        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, ResponseText, FindBlobsByTagsOperationNotSuccessfulErr);
        FoundBlobs := FormatHelper.TextToXmlDocument(ResponseText);
        exit(OperationResponse);
    end;

    procedure DeleteBlob(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::DeleteBlob);
        OperationResponse := BlobAPIWebRequestHelper.DeleteOperation(OperationPayload, StrSubstNo(DeleteBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName(), 'Delete'));
        exit(OperationResponse);
    end;

    procedure UndeleteBlob(): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::UndeleteBlob);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, StrSubstNo(DeleteBlobOperationNotSuccessfulErr, OperationPayload.GetBlobName(), OperationPayload.GetContainerName(), 'Undelete'));
        exit(OperationResponse);
    end;

    procedure CopyBlob(SourceName: Text; LeaseId: Guid): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::CopyBlob);
        BlobAPIValueHelper.SetCopySourceNameHeader(OperationPayload, SourceName);
        if not IsNullGuid(LeaseId) then
            BlobAPIValueHelper.SetLeaseIdHeader(OperationPayload, LeaseId);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, StrSubstNo(CopyOperationNotSuccessfulErr, SourceName, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure CopyBlobFromURL(SourceUri: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
    begin
        OperationPayload.SetOperation(Operation::CopyBlobFromUrl);
        BlobAPIValueHelper.SetCopySourceNameHeader(OperationPayload, SourceUri);
        BlobAPIValueHelper.SetRequiresSyncHeader(OperationPayload, true);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, CopyOperationNotSuccessfulErr);
        exit(OperationResponse);
    end;

    procedure PutBlock(SourceContent: Variant): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
    begin
        OperationResponse := PutBlock(SourceContent, FormatHelper.GetBase64BlockId());
        exit(OperationResponse);
    end;

    procedure PutBlock(SourceContent: Variant; BlockId: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
        SourceStream: InStream;
        SourceText: Text;
    begin
        OperationPayload.SetOperation(Operation::PutBlock);
        BlobAPIValueHelper.SetBlockIdParameter(OperationPayload, BlockId);
        case true of
            SourceContent.IsInStream():
                begin
                    SourceStream := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceStream);
                end;
            SourceContent.IsText():
                begin
                    SourceText := SourceContent;
                    BlobAPIHttpContentHelper.AddBlobPutBlockBlobContentHeaders(Content, OperationPayload, SourceText);
                end;
        end;

        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(PutBlockOperationNotSuccessfulErr, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;

    procedure GetBlockList(BlockListType: Enum "Block List Type"; var CommitedBlocks: Dictionary of [Text, Integer]; var UncommitedBlocks: Dictionary of [Text, Integer]): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        HelperLibrary: Codeunit "Blob API Helper Library";
        Document: XmlDocument;
    begin
        OperationResponse := GetBlockList(BlockListType, Document);
        HelperLibrary.BlockListResultToDictionary(Document, CommitedBlocks, UncommitedBlocks);
        exit(OperationResponse);
    end;

    procedure GetBlockList(var BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        BlockListType: Enum "Block List Type";
    begin
        OperationResponse := GetBlockList(BlockListType::committed, BlockList); // default API value is "committed"
        exit(OperationResponse);
    end;

    procedure GetBlockList(BlockListType: Enum "Block List Type"; var BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
        Operation: Enum "Blob Service API Operation";
        ResponseText: Text;
    begin
        OperationPayload.SetOperation(Operation::GetBlockList);
        BlobAPIValueHelper.SetBlockListTypeParameter(OperationPayload, BlockListType);
        OperationResponse := BlobAPIWebRequestHelper.GetOperationAsText(OperationPayload, ResponseText, StrSubstNo(BlockListOperationNotSuccessfulErr, OperationPayload.GetBlobName(), 'get'));
        BlockList := FormatHelper.TextToXmlDocument(ResponseText);
        exit(OperationResponse);
    end;

    procedure PutBlockList(CommitedBlocks: Dictionary of [Text, Integer]; UncommitedBlocks: Dictionary of [Text, Integer]): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        FormatHelper: Codeunit "Blob API Format Helper";
        BlockList: Dictionary of [Text, Text];
        BlockListAsXml: XmlDocument;
    begin
        FormatHelper.BlockDictionariesToBlockListDictionary(CommitedBlocks, UncommitedBlocks, BlockList, false);
        BlockListAsXml := FormatHelper.BlockListDictionaryToXmlDocument(BlockList);
        OperationResponse := PutBlockList(BlockListAsXml);
        exit(OperationResponse);
    end;

    procedure PutBlockList(BlockList: XmlDocument): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
    begin
        OperationPayload.SetOperation(Operation::PutBlockList);
        BlobAPIHttpContentHelper.AddBlockListContent(Content, OperationPayload, BlockList);
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(BlockListOperationNotSuccessfulErr, OperationPayload.GetBlobName(), 'put'));
        exit(OperationResponse);
    end;

    procedure PutBlockFromURL(SourceUri: Text; BlockId: Text): Codeunit "Blob API Operation Response"
    var
        OperationResponse: Codeunit "Blob API Operation Response";
        Operation: Enum "Blob Service API Operation";
        Content: HttpContent;
    begin
        OperationPayload.SetOperation(Operation::PutBlockFromURL);
        BlobAPIValueHelper.SetCopySourceNameHeader(OperationPayload, SourceUri);
        BlobAPIValueHelper.SetBlockIdParameter(OperationPayload, BlockId);
        OperationPayload.AddHeader('Content-Length', '0');
        OperationResponse := BlobAPIWebRequestHelper.PutOperation(OperationPayload, Content, StrSubstNo(PutBlockFromUrlOperationNotSuccessfulErr, SourceUri, OperationPayload.GetBlobName()));
        exit(OperationResponse);
    end;
    #endregion
}