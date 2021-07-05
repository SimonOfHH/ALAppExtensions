// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Defines a unified storage service client that provides means for authorization.
/// </summary>
interface "Storage Service REST Operation"
{
    /// <summary>
    /// Adds a header to the strorage client.
    /// </summary>
    /// <param name="HeaderName">The name of the header.</param>
    /// <param name="HeaderValue">The values of the header.</param>
    procedure AddHeader(HeaderName: Text; HeaderValue: Text);

    /// <summary>
    /// Adds a paramer to the storage client.
    /// </summary>
    /// <param name="ParameterName">The name of the parameter.</param>
    /// <param name="ParameterValue">The value of the parameter.</param>
    procedure AddParameter(ParameterName: Text; ParameterValue: Text);

    /// <summary>
    /// Gets the API version the client is using.
    /// </summary>
    /// <returns>The API version the client is using.</returns>
    procedure GetAPIVersion(): Enum "Storage Service API Version";

    /// <summary>
    /// Gets the storage account name the client is using.
    /// </summary>
    /// <returns>The storage account name the client is using.</returns>
    procedure GetStorageAccountName(): Text;
}