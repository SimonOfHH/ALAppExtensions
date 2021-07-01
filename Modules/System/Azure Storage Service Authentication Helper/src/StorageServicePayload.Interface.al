// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// TODO
/// </summary>
interface "Storage Service Payload"
{
    procedure AddHeader(HeaderName: Text; HeaderValue: Text);

    procedure AddParameter(ParameterName: Text; ParameterValue: Text);

    procedure GetAPIVersion(): Enum "Storage Service API Version";

    procedure GetStorageAccountName(): Text;
}